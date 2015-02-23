require 'aws-sdk'
class DataUploadersController < ApplicationController
  respond_to :html, :js, :json
  add_breadcrumb "Home", :root_path, :options => { :title => "Home" }
  def file_upload
    initalize_breadcrumb("File Upload", fileupload_datauploaders_path)
  end
  
  def file_upload_to_amazon
    selected_file_name = params[:selected_file_name]
    puts "*************************************"
    puts selected_file_name    
    table_name= (current_user.id).to_s + DateTime.now.strftime('%Q').downcase.pluralize
    uploaded_file_name = params[:file].original_filename  
    #insert into a record user file mapping ....       
    bucket = S3_BUCKET      
    object = bucket.objects[table_name]
    #write file into S3
    begin
      if selected_file_name != '' then
        is_process_complete = DataUploader.delete_existing_data_source(selected_file_name)
      end
      #objecterroe = bucket.objects['error'+table_name]
      object.write(:file => params[:file]) 
      #objecterroe.write(:file => object.read)
      add_file_detail = UserFileMapping.insert_uploaded_file_record(current_user, uploaded_file_name, table_name, Constant.file_upload_status_constants[:file_successfully_uploaded])
      # create a thread for process on file      
      Thread.new do
       process_on_file(object.read,table_name)   
      end         
      @json_res = {:is_error => false, :error_message => ""}
      respond_to do |format|  
        format.json { render :json => [@json_res]}
      end
    rescue Exception => err
      add_file_detail = UserFileMapping.insert_uploaded_file_record(current_user, uploaded_file_name, table_name, Constant.file_upload_status_constants[:file_not_uploaded])      
      @json_res = {:is_error => true, :error_message => "Error in file <i>#{uploaded_file_name} </i>upload"}
      respond_to do |format|  
        format.json { render :json => [@json_res]}
      end
    end           
  end 
  # show upload csv generated table schema
  def show_uploaded_schema
    initalize_breadcrumb("Uploaded File(s)", uploadedfile_datauploaders_path)
    @table_name = params[:table_name]
    @uploaded_schema = DataUploader.get_uploaded_schema(@table_name)
    if @uploaded_schema.size>0
      @disabled_column = get_user_table_column_info(@table_name)
      check_record_uploaded = UserFileMapping.where(:table_name => @table_name).first
      @is_record_uploaded = false
      if check_record_uploaded then
        @is_record_uploaded = check_record_uploaded.is_record_uploaded
      end
      initalize_breadcrumb("Uploaded File Schema", showuploadedschema_datauploaders_path({:table_name => @table_name}))
    else
      redirect_to uploadedfile_datauploaders_path, :flash => { :error => "Table schema not exists" }
    end
  end

  # find uploaded files details
  def uploaded_file
    initalize_breadcrumb("Uploaded File(s)", uploadedfile_datauploaders_path)
    currentUser = current_user.id
    @uploadedFiles = UserFileMapping.where(:user_id =>currentUser )
    respond_with(@uploadedFiles)
  end

  # find uploaded file records
  def upload_file_record
    initalize_breadcrumb("Uploaded File(s)", uploadedfile_datauploaders_path)
    @table_record = {data:[], draw: 1, recordsTotal:"0", recordsFiltered:"0",columns:[]}
    @table_name = params[:table_name]
    @summary = {total_record: 0, success_record: 0, error_record: 0}
    user_file_mappings = UserFileMapping.where(:table_name => @table_name).first
    #byebug
    @summary[:total_record] = user_file_mappings.total_records  ? user_file_mappings.total_records : 0
    @summary[:success_record] = user_file_mappings.success_records  ? user_file_mappings.success_records : 0
    @summary[:error_record] = user_file_mappings.error_records ? user_file_mappings.error_records : 0
    if @summary[:total_record] >= 0 then
      @summary[:success_record] = @summary[:success_record] == 0 ? 0 : ((@summary[:success_record].to_f/@summary[:total_record])*100).round(2)
      @summary[:error_record] = @summary[:error_record] == 0 ? 0 : ((@summary[:error_record].to_f/@summary[:total_record])*100).round(2)
    end
    page_size = 10
    page_index = 0
    draw = 1
    search_value = '' 
    order_column_index=0
    order_column_name =''
    order_type ="ASC"
    if params[:search] != nil then
      search_value = params[:search]["value"]
    end

    if (params[:length])
        page_size = params[:length]
    end

    if (params[:start])
        page_index = params[:start]
    end

    if (params[:draw])
        draw = params[:draw]
        @table_record[:draw]=draw
    end    

    if params[:columns] != nil then
      params[:columns].each do |columns|        
        @table_record[:columns].append(columns[1]["data"])
      end
    end
    if params[:order] != nil then
        params[:order].each do |order|          
         order_column_index = order[1]["column"]
         order_type = order[1]["dir"]         
        end        
    end 
   
    if @table_record[:columns].size > 0      
      order_column_name=@table_record[:columns][order_column_index.to_i]
    end  

    response = DataUploader.get_table_data(@table_name, page_size, page_index, order_column_name,order_type,search_value, @table_record[:columns])
    if response.to_a.size > 0 then        
      response.each do |record|         
        @table_record[:recordsTotal] = record["totalrecord"]
        @table_record[:recordsFiltered] = record["filterrecord"]
        @table_record[:data].append(record)
      end     
    end
    initalize_breadcrumb("Uploaded File Record(s)", uploadfilerecord_datauploaders_path)    
    respond_to do |format| 
      format.html 
      format.js  
      format.json { render :json => @table_record}
    end

  end

   # find uploaded file records
  def upload_file_record_json
   initalize_breadcrumb("Uploaded File Record(s)", uploadfilerecord_datauploaders_path) 
    @table_name = params[:table_name]   
    @table_record=[]
    response = DataUploader.get_table_data_without_pagination(@table_name)
    if response.to_a.size > 0 then        
      response.each do |record| 
        @table_record.append(record)
      end     
    end       
    respond_to do |format| 
      format.html       
      format.js  
      format.json { render :json => @table_record}
    end

  end

  def change_table_column_detail
    @uploaded_records=[]
    respond_with(@uploaded_records)
  end

  def column_exclude_include
    table_name = params[:table_name]
    column_name = params[:column_name]
    is_column_disabled = params[:is_column_disabled]
    errors = ""
    update_column_info = UserTableColumnInformation.update_column_information(current_user, is_column_disabled, table_name, column_name)
    if update_column_info.errors.any?
      update_column_info.errors.full_messages.each do |message|
        errors = errors + message + "\n"
      end
    end
    respond_to do |format|
      format.html { redirect_to showuploadedschema_datauploaders_path({:table_name => table_name}), notice: (errors.size ==0 ? "Column detail update Successfully": errors)  }
      format.json { head :no_content }
    end
  end

  def delete_user_file_mapping_record
    table_name = params[:table_name]
    response = DataUploader.check_table_exist(table_name)
    if response.to_a.size > 0 then
      DataUploader.drop_table_if_exist(table_name)
    end
    delete_user_file_mapping_record = UserFileMapping.find_by(:table_name => table_name).destroy
    redirect_to uploadedfile_datauploaders_path, :flash => { :notice => "Data source deleted successfully." }
  end

  # find uploaded file records
  def upload_file_columns_for_record
    @table_columns = {columns: []}
    table_name = params[:table_name] 
    uploaded_schema = DataUploader.get_uploaded_schema(table_name)
    if uploaded_schema.size > 0
        disabled_column = get_user_table_column_info(table_name)
        uploaded_schema.each do |schema|
          if !(disabled_column.include?schema[:Field]) then            
            @table_columns[:columns].append({title: schema[:Field], data: schema[:Field]})
          end
        end          
        respond_to do |format| 
          format.html       
          format.js  
          format.json { render :json => @table_columns}
        end
    else
      redirect_to uploadedfile_datauploaders_path, :flash => { :error => "Table schema does not exists" }
    end
  end

  def process_on_file(csvdatafile, table_name)   
      csv_data = []       
      max_row_size = 0            
      columns = []
      is_repeated_column = false
      error_record_list = []
      error_row_num_list = []      
      # filter error records, check is file contain repated column     
      CSV.parse(csvdatafile).each_with_index do |row, row_id| 
        if row_id  == 0
          columns = row.to_a
          if columns.uniq.size != columns.size 
            is_repeated_column = true
            break
          end
          max_row_size = columns.size
        elsif max_row_size == row.to_a.size
          temp_row = row.to_a
          if DataUploader.contain_blank_value(temp_row) 
            error_row_num_list.append(row_id)
            error_record_list.append({:row_id => row_id+1, :error => "Record cannot be inserted due to blank values for all columns", :error_record => row.to_a})
          else
            csv_data.append(row.to_a)
          end              
        else
          error_row_num_list.append(row_id)
          error_record_list.append({:row_id => row_id, :error => "Record cannot be inserted due to unmatched length with header", :error_record => row.to_a})
        end                  
      end 
      puts "################### CSV DATA IS READY ##########################"  
      puts csv_data.size   
      if csv_data.size > 0 then
        @columns_detail = []
        if is_repeated_column  then        
          add_file_detail = UserFileMapping.update_uploaded_file_status(table_name, Constant.file_upload_status_constants[:file_uploaded_with_error])
          FileUploadErrorMessage.create(
                              table_name: table_name,
                              error_message: "Unable to analyze the CSV due to repeated columns")
        else        
          csv_data = csv_data.transpose
          columns.each_with_index do |column, colindex|
            puts ":::::::::::::: COLUMNS ::::::::::::::::::"
            puts column
            puts colindex
            column = column.gsub(/[^0-9A-Za-z]/, '').strip.tr(' ', '').downcase
            column = (column == nil) ||(column == "null") || (column == "nil") || (column == "") ? "column" + colindex.to_s : column                            
            column_detail = {column_name: column,
                            is_nullable: false,
                            data_type: "",
                            date_format:"",
                            time_format: "",
                            field_length: "0",
                            money_symbol: "",
                            is_money_format: false,
                            money_symbol_position: "",
                            is_percentage: false,
                            is_unique: true}
          
            #trim blank spaces at beginning and end
            csv_data[colindex] = csv_data[colindex].collect{|x| if (x!=nil) then x.strip end}
            
            # check column contain more than 1 value of nil and blank
            if ((csv_data[colindex].count(nil) > 1) || (csv_data[colindex].count("") > 1)) then
              column_detail[:is_unique] = false
            end
            # check column is nullable
            if ((csv_data[colindex].count(nil) > 0) || (csv_data[colindex].count("") > 0)) then
              column_detail[:is_nullable] = true
            end
            #removing blank, null and nil values from array
            csv_data[colindex] = csv_data[colindex].reject { |c| c.blank? }
            # convert in downcase each value of array
            csv_data[colindex] = csv_data[colindex].map(&:downcase)
            if ((csv_data[colindex].count("null") > 1) && (column_detail[:is_unique] == true))then
              column_detail[:is_unique] = false
            end
            # check column is nullable and delete "null" or "nil" values 
            if ((csv_data[colindex].count("null") > 0) || (csv_data[colindex].count("nil") > 0)) then
              column_detail[:is_nullable] = true
              if ((csv_data[colindex].include? 'null') == true) then
                csv_data[colindex].delete("null")
              end
              if ((csv_data[colindex].include? 'nil') == true) then
                csv_data[colindex].delete("nil")
              end
            end
            # check column is unique values 
            if column_detail[:is_unique] then
              if csv_data[colindex].size == csv_data[colindex].uniq.size  then
                column_detail[:is_unique] = true
              else
                column_detail[:is_unique] = false
              end
            end
            # set default field length 
            if csv_data[colindex].size == 0 then
              column_detail[:data_type] = "string"
              column_detail[:field_length] = "10"
            else
              if csv_data[colindex].size > 0 then
                # Check array containing integer values only
                if column_detail[:data_type]=="" then
                  begin
                    bool_arr = ['true', '1', 'yes', 'on', 'false', '0', 'no', 'off', 0, 1]
                    if (csv_data[colindex] - bool_arr).empty? then
                      column_detail[:data_type] = "boolean"
                    end
                  rescue
                    # catch code at here
                  end
                end
                is_datetime = false
                input_field_splitter_used = ''
                if (((csv_data[colindex].collect{|v| v.include? '-'}).uniq).include? false)== false then
                input_field_splitter_used = '-'
                  is_datetime = true
                end
                if (((csv_data[colindex].collect{|v| v.include? '/'}).uniq).include? false) == false then
                input_field_splitter_used = '/'
                  is_datetime = true
                end
                if is_datetime then
                  puts "################### Csv Data csv_data ##########################"
                  puts  csv_data[colindex]
                  temp_arr = csv_data[colindex].collect{|x| x.tr("-/", ' ')}
                  puts "################### Csv Data DAte ##########################"
                  puts temp_arr
                  # Check array containing date values only
                  if column_detail[:data_type] == "" then
                    begin                  
                      is_data_integer=temp_arr.collect{|val| Date.strptime(val, "%m %d %Y")}
                      column_detail[:data_type] = "datetime"
                      column_detail[:date_format] = "%m" + input_field_splitter_used + "%d" + input_field_splitter_used + "%Y"
                      column_detail[:time_format]= DataUploader.check_is_date_time(temp_arr, "%m %d %Y")
                    rescue
                      # catch code at here
                    end
                  end
                  # Check array containing date values only
                  if column_detail[:data_type] == "" then
                    begin
                      is_data_integer=temp_arr.collect{|val| Date.strptime(val, "%d %m %Y")}
                      column_detail[:data_type] = "datetime"
                      column_detail[:date_format] = "%d" + input_field_splitter_used + "%m" + input_field_splitter_used + "%Y"
                      column_detail[:time_format]= DataUploader.check_is_date_time(temp_arr, "%m %d %Y")
                    rescue
                      # catch code at here
                    end
                  end
                  # Check array containing date values only
                  if column_detail[:data_type] == "" then
                    begin
                      is_data_integer=temp_arr.collect{|val| Date.strptime(val, "%Y %m %d")}
                      column_detail[:data_type] = "datetime"
                      column_detail[:date_format]="%Y" + input_field_splitter_used +  "%m" + input_field_splitter_used + "%d"
                      column_detail[:time_format]= DataUploader.check_is_date_time(temp_arr, "%m %d %Y")
                    rescue
                      # catch code at here
                    end
                  end
                  # Check array containing date values only
                  if column_detail[:data_type] == "" then
                    begin
                      is_data_integer=temp_arr.collect{|val| Date.strptime(val, "%Y %d %m")}
                      column_detail[:data_type] = "datetime"
                      column_detail[:date_format] = "%Y" + input_field_splitter_used +  "%d" + input_field_splitter_used + "%m"
                      column_detail[:time_format]= DataUploader.check_is_date_time(temp_arr, "%m %d %Y")
                    rescue
                      # catch code at here
                    end
                  end
                  # Check array containing date values only
                  if column_detail[:data_type] == "" then
                    begin
                      is_data_integer=csv_data[colindex].collect{|val| DateTime.parse(val)}
                      column_detail[:data_type] = "datetime"
                    rescue
                      # catch code at here
                    end
                  end
                end
                # Check array containing integer values only
                if column_detail[:data_type]=="" then
                  begin
                    is_data_integer=csv_data[colindex].collect{|val| Integer(val)}
                    column_detail[:data_type] = "integer"
                    temp_arr = csv_data[colindex].collect{|val| Integer(val) == 0 ? "0" : val }
                    temp_arr.delete("0")
                    is_string = false
                    temp_arr.each do |temp_arr_val|
                      if temp_arr_val[0] == "0" then
                        is_string = true
                        break
                      end
                    end
                    if is_string == true then
                      column_detail[:data_type] = "string"
                    end                
                  rescue
                    # catch code at here
                  end
                end  
                # check array containing money format
                if column_detail[:data_type]=="" then
                  begin
                    money_symbol = ''
                    symbol_length = 0
                    #byebug
                    money_symbols = ['$','€','£','¥','Fr','kr','zł','Ft','Kč','A$','R$','RM','₱','NT$','฿', 'TRY', '₹']
                    money_symbols.each do |symbol|
                      symbol_length = symbol.size
                      if (csv_data[colindex].collect{|k| k[0...symbol_length]}.uniq)[0] == symbol then
                        money_symbol = symbol
                        column_detail[:is_money_format] = true
                        column_detail[:money_symbol_position] = "start"
                      break
                      end
                      if (csv_data[colindex].collect{|k| k[(k.size-symbol_length)...k.size]}.uniq)[0] == symbol then
                        money_symbol = symbol
                        column_detail[:is_money_format] = true
                        column_detail[:money_symbol_position] = "end"
                        break
                      end
                    end
                    if money_symbol != '' then
                      temp_arr = csv_data[colindex].collect{|x| x.tr(money_symbol, '').strip}
                      is_data_integer=temp_arr.collect{|val| Float(val.gsub(/,/,''))}
                      max_length_after_decimal = (((temp_arr.map{|k| k.split('.')[1]}).reject { |c| c.blank? }).group_by(&:size).max.last)[0].size
                      max_length_before_decimal = (((temp_arr.map{|k| k.split('.')[0]}).reject { |c| c.blank? }).group_by(&:size).max.last)[0].size
                      column_detail[:field_length] = (max_length_before_decimal + max_length_after_decimal + 1).to_s + "," + max_length_after_decimal.to_s
                      column_detail[:data_type] = "decimal"
                      column_detail[:money_symbol] = money_symbol
                    end
                  rescue
                    # catch code at here
                  end
                end
                # check array containing percentage format
                if column_detail[:data_type]=="" then
                  begin
                    symbol_length = 1
                    percent_symbols = ['%']
                    percent_symbols.each do |symbol|
                      if (csv_data[colindex].collect{|k| k[0...symbol_length]}.uniq)[0] == symbol then
                        column_detail[:is_percentage] = true
                        break
                      end
                      if (csv_data[colindex].collect{|k| k[(k.size-symbol_length)...k.size]}.uniq)[0] == symbol then
                        column_detail[:is_percentage] = true
                        break
                      end
                    end
                    if column_detail[:is_percentage] then
                      temp_arr = csv_data[colindex].collect{|x| x.tr('%', '').strip}
                      is_data_integer=temp_arr.collect{|val| Float(val.gsub(/,/,''))}
                      max_length_after_decimal = (((temp_arr.map{|k| k.split('.')[1]}).reject { |c| c.blank? }).group_by(&:size).max.last)[0].size
                      max_length_before_decimal = (((temp_arr.map{|k| k.split('.')[0]}).reject { |c| c.blank? }).group_by(&:size).max.last)[0].size
                      column_detail[:field_length] = (max_length_before_decimal + max_length_after_decimal + 1).to_s + "," + max_length_after_decimal.to_s
                      column_detail[:data_type] = "decimal"
                    end
                  rescue
                    # catch code at here
                  end
                end
                # Check array containing float values only
                if column_detail[:data_type]=="" then
                  begin
                    is_data_integer = csv_data[colindex].collect{|val| Float(val)}
                    max_length_after_decimal = (((csv_data[colindex].map{|k| k.split('.')[1]}).reject { |c| c.blank? }).group_by(&:size).max.last)[0].size
                    max_length_before_decimal = (((csv_data[colindex].map{|k| k.split('.')[0]}).reject { |c| c.blank? }).group_by(&:size).max.last)[0].size
                    column_detail[:field_length] = (max_length_before_decimal + max_length_after_decimal + 1).to_s + "," + max_length_after_decimal.to_s
                    column_detail[:data_type] = "decimal"
                  rescue
                    # catch code at here
                  end
                end
                if column_detail[:data_type] == "" then
                  begin
                    is_data_integer=csv_data[colindex].collect{|val| DateTime.parse(val)}
                    column_detail[:data_type] = "datetime"
                  rescue
                    # catch code at here
                  end
                end
                # Check array containing string values
                if column_detail[:data_type]=="" then
                  begin
                    is_data_integer = csv_data[colindex].collect{|val| String(val)}
                    column_detail[:data_type] = "string"
                  rescue
                    # catch code at here
                  end
                end
                if column_detail[:data_type]!= 'decimal' then
                  column_detail[:field_length] = ((csv_data[colindex].group_by(&:size).max.last)[0].size) + 1
                end
              end
            end
            @columns_detail.append(column_detail)
          end 
          is_table_created = DataUploader.create_dynamic_table(table_name, @columns_detail)
          if is_table_created
            begin
              @columns_detail.each do |column|
                if ((column[:is_money_format]==true) || (column[:is_percentage] == true)) then
                  update_column_info=UserTableColumnInformation.create(
                      table_name: table_name,
                      column_name: column[:column_name],
                      money_format:  column[:money_symbol],
                      is_disable: false,
                      is_percentage_value: column[:is_percentage],
                      created_by: current_user.id,
                      created_on: Time.now ,
                      modified_by: current_user.id,
                      modified_on: Time.now)
                end
              end
              user_table_mapping = UserFileMapping.where("table_name =?", table_name).first
              if user_table_mapping then
                user_table_mapping.is_table_created = true
                user_table_mapping.has_error_record = error_row_num_list.size > 0?true:false
                user_table_mapping.save
              end
            rescue      
            end             
            DataUploader.insert_csv_data(csvdatafile, table_name, @columns_detail, error_row_num_list)
            if error_record_list.size > 0 then
              DataUploader.insert_error_detail(table_name, error_record_list)
            end
            respond_to do |format|          
              format.json { render :json =>true}
            end
          else
            respond_to do |format|          
              format.json { render :json =>false}
            end
          end
  	    end
      else
        UserFileMapping.update_uploaded_file_status(table_name, Constant.file_upload_status_constants[:file_uploaded_with_no_record])
      end
  end

  def show_error_record
    initalize_breadcrumb("Uploaded File(s)", uploadedfile_datauploaders_path)    
    @result = []
    @table_name = params[:table_name]
    @is_schema_error = params[:is_schema_error]
    if @is_schema_error == "true" then      
      @result = FileUploadErrorMessage.table_upload_error_record(@table_name)
    else
      @summary = {total_record: 0, success_record: 0, error_record: 0}
      user_file_mappings = UserFileMapping.where(:table_name => @table_name).first
      @summary[:total_record] = user_file_mappings.total_records  ? user_file_mappings.total_records : 0
      @summary[:success_record] = user_file_mappings.success_records  ? user_file_mappings.success_records : 0
      @summary[:error_record] = user_file_mappings.error_records ? user_file_mappings.error_records : 0
      if @summary[:total_record] >= 0 then
        @summary[:success_record] = @summary[:success_record] == 0 ? 0 :((@summary[:success_record].to_f/@summary[:total_record])*100).round(2)
        @summary[:error_record] = @summary[:error_record] == 0 ? 0 : ((@summary[:error_record].to_f/@summary[:total_record])*100).round(2)
      end
      @result = TableErrorRecord.table_error_record(@table_name)
    end    
    initalize_breadcrumb("Error Record(s)", showerrorrecord_datauploaders_path)
    respond_with(@result, @is_schema_error)
  end
  
  def restart_insertion
    table_name = params[:table_name]        
    response = DataUploader.check_table_exist(table_name)
    if response.to_a.size > 0 then      
      user_table_mapping = UserFileMapping.where(:table_name => table_name.to_s).first
      initial_user_file_name = user_table_mapping[:file_name]
      DataUploader.drop_table_if_exist(table_name)
      user_table_mapping.destroy
      #insert into a record user file mapping ....       
      bucket = S3_BUCKET      
      object = bucket.objects[table_name]
      #write file into S3
      add_file_detail = UserFileMapping.insert_uploaded_file_record(current_user, initial_user_file_name, table_name, Constant.file_upload_status_constants[:file_successfully_uploaded])
      # create a thread for process on file      
      Thread.new do
       process_on_file(object.read,table_name)   
      end
    end
    redirect_to uploadedfile_datauploaders_path, :flash => { :notice => "Data processing restarted." }
  end

  def check_file_uploaded
    file_name = params[:file_name]        
    response = UserFileMapping.where(:file_name => file_name.to_s)
    return_result = {:is_file_exits => false, :matching_record => []}
    if response.to_a.size > 0 then
      return_result[:is_file_exits] = true
      return_result[:matching_record] = response.to_a
    end
    respond_to do |format|  
        format.json { render :json => [return_result]}
    end
  end

  def delete_complete_data_source
    table_name = params[:table_name] 
    is_process_complete = DataUploader.delete_existing_data_source(table_name)
    result_obj = is_process_complete ? {:notice =>"Data source remove successfully." } :{:error =>"Error in removing data source. Please try again or contact admin." }
    redirect_to uploadedfile_datauploaders_path, :flash => result_obj
  end
end
