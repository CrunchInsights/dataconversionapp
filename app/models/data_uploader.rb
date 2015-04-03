require 'smarter_csv'
class DataUploader < ActiveRecord::Base
  def self.create_dynamic_table(table_name, column_structure_object)
    begin
      unique_columns = []
      puts column_structure_object
      if column_structure_object.size > 0
        ActiveRecord::Schema.define do
          create_table "#{table_name}", :id => false do |t|
            column_structure_object.each do |column_struct|
              case column_struct[:data_type]
                when 'boolean'
                  t.column column_struct[:column_name], column_struct[:data_type], null: column_struct[:is_nullable]
                when 'decimal'
                  t.column column_struct[:column_name], column_struct[:data_type], null: column_struct[:is_nullable], precision: (column_struct[:field_length].split(',')[0]).to_i, scale: (column_struct[:field_length].split(',')[1]).to_i
                when 'datetime'
                  t.column column_struct[:column_name], column_struct[:data_type], null: column_struct[:is_nullable]
                when 'time'
                  t.column column_struct[:column_name], column_struct[:data_type], null: column_struct[:is_nullable]               
                when 'integer'
                  if column_struct[:is_unique] == true then
                    unique_columns.append(column_struct[:column_name])
                  end
                  t.column column_struct[:column_name], column_struct[:data_type], null: column_struct[:is_nullable]
                else
                  if column_struct[:is_unique] == true then
                    unique_columns.append(column_struct[:column_name])
                  end
                  t.column column_struct[:column_name], column_struct[:data_type], null: column_struct[:is_nullable], limit: column_struct[:field_length]
              end
            end
          end
          unique_columns.each do |uniqCol|
            add_index table_name, uniqCol, unique: true
          end
        end
      end
      return true
    rescue Exception => err
      return err.message
    end
  end
  def self.get_uploaded_schema(table_name)
    uploaded_schema = []
    begin
      my_sql= "Select temp.column_name as field, temp.data_type as field_data_type_long, temp.character_maximum_length as field_length,
      temp.is_nullable as nullable, temp.udt_name as type,
      CASE
      WHEN temp2.indisprimary = 't' THEN 'PRIMARY'
      WHEN temp2.indisunique = 't' THEN 'UNIQUE'
      ELSE ''
      END AS key
      from (select isc.column_name, isc.data_type, isc.character_maximum_length, isc.is_nullable, isc.udt_name
      from INFORMATION_SCHEMA.COLUMNS isc WHERE isc.table_name = '#{table_name}') as temp
      LEFT JOIN (SELECT pga.attname, pgi.indisunique, pgi.indisprimary
      FROM pg_index pgi
      LEFT JOIN pg_class pgc
      ON pgi.indrelid  = pgc.oid
      LEFT JOIN pg_attribute pga
      ON pga.attrelid = pgc.oid
      AND pga.attnum = ANY(indkey)
      WHERE pgc.relname =  '#{table_name}' ) as temp2
      ON temp.column_name = temp2.attname;"
      #my_sql = "DESC"

      result_set = ActiveRecord::Base.connection.execute(my_sql)

      result_set=result_set.to_a
      if result_set.size > 0
        result_set.each do |result|
          result_schema = {}
          result_schema[:Field] = result["field"]
          result_schema[:Type] = result["type"]
          result_schema[:Null] = result["nullable"]
          result_schema[:Key] = result["key"]
          result_schema[:money_symbol] = ''
          result_schema[:is_percentage] = false
          uploaded_schema.append(result_schema)

        end
      end
      return uploaded_schema
    rescue
      return uploaded_schema
    end
  end
  def self.insert_csv_data(csv_file_data, table_name, column_structure_object, error_row_num_list)
    if column_structure_object.size > 0
      table_columns = []
      column_structure_object.each do |column_name|
        table_columns.append(column_name[:column_name])
      end
      table_col_str = table_columns.map{|col| "\"#{col}\""}.join(', ')
      total_record = 0
      error_record_count = 0
      success_record = 0
      chunk = 0
      inserted_row_arr=[]
      record_inserted_successfully = true
      ActiveRecord::Base.transaction do
        begin
          CSV.parse(csv_file_data).each_with_index do |row, row_id|             
            if row_id > 0
              if !(error_row_num_list.include? row_id) then
                inserted_row_string=''
                row.each_with_index do |inserted_row_value,col_index|
                  begin
                        if inserted_row_value == nil then
                          inserted_row_string = inserted_row_string + 'NULL, '
                        elsif ((inserted_row_value.to_s.strip.downcase == 'null') || (inserted_row_value.to_s.strip.downcase) == "nil" || (inserted_row_value.to_s.strip == "")) then
                          inserted_row_string = inserted_row_string + 'NULL, '
                        else
                          if column_structure_object[col_index][:data_type] == "datetime" then
                            if column_structure_object[col_index][:date_format] != "" then
                              if column_structure_object[col_index][:time_format] != "" then
                                inserted_row_string = inserted_row_string + "'" + DateTime.strptime(inserted_row_value.strip, "#{column_structure_object[col_index][:date_format]} #{column_structure_object[col_index][:time_format]}").strftime("%Y-%m-%d %H:%M:%S").to_s + "', "
                              else
                                inserted_row_string = inserted_row_string + "'" + DateTime.strptime(inserted_row_value.strip, column_structure_object[col_index][:date_format]).strftime("%Y-%m-%d %H:%M:%S").to_s + "', "
                              end
                            else
                              inserted_row_string = inserted_row_string + "'" + DateTime.parse(inserted_row_value.strip).strftime("%Y-%m-%d %H:%M:%S").to_s + "', "
                            end
                          elsif column_structure_object[col_index][:data_type] == "integer" then
                            inserted_row_string = inserted_row_string + inserted_row_value.to_s.to_s + ", "
                          elsif column_structure_object[col_index][:data_type] == "decimal" then
                            if column_structure_object[col_index][:is_money_format] == true
                              inserted_row_value = inserted_row_value.to_s.tr(column_structure_object[col_index][:money_symbol],'').strip
                              inserted_row_string = inserted_row_string + "'" + inserted_row_value.gsub(/,/,'').to_s + "', "
                            elsif column_structure_object[col_index][:is_percentage] == true
                              inserted_row_value = inserted_row_value.to_s.tr('%','').strip
                              inserted_row_string = inserted_row_string + "'" + inserted_row_value.gsub(/,/,'').to_s + "', "
                            else                      
                              inserted_row_string = inserted_row_string + "'" + inserted_row_value.to_s + "', "
                            end
                          elsif column_structure_object[col_index][:data_type] == "string" then
                            inserted_row_string = inserted_row_string + "'" + inserted_row_value.strip.to_s + "', "
                          elsif column_structure_object[col_index][:data_type] == "time" then
                            inserted_row_string = inserted_row_string + "'" + (inserted_row_value.strip.to_time).to_s + "', "
                          elsif column_structure_object[col_index][:data_type] == "boolean" then
                            if inserted_row_value == 'on' then
                              inserted_row_string = inserted_row_string + true.to_s + ", "
                            elsif inserted_row_value == 'off' then
                              inserted_row_string = inserted_row_string + false.to_s + ", "
                            elsif inserted_row_value == 1 then
                              inserted_row_string = inserted_row_string + true.to_s + ", "
                            elsif inserted_row_value == 0 then
                              inserted_row_string = inserted_row_string + false.to_s + ", "
                            elsif inserted_row_value == 'yes' then
                              inserted_row_string = inserted_row_string + true.to_s + ", "
                            elsif inserted_row_value == 'no' then
                              inserted_row_string = inserted_row_string + false.to_s + ", "
                            elsif inserted_row_value == '1' then
                              inserted_row_string = inserted_row_string + true.to_s + ", "
                            elsif inserted_row_value == '0' then
                              inserted_row_string = inserted_row_string + false.to_s + ", "
                            else
                              inserted_row_string = inserted_row_string + inserted_row_value.to_s.strip + ", "
                            end
                          end
                        end
                  rescue  Exception => err
                    record_inserted_successfully = false
                    raise ActiveRecord::Rollback                    
                  end                         
                end             
                if(inserted_row_string.size > 0)
                  inserted_row_string = inserted_row_string[0...-2]
                  values='('+inserted_row_string+')'             
                  inserted_row_arr.append(values)                                     
                end                        
                chunk=chunk + 1           
                if chunk > 2 then
                  chunk=0
                  my_sql="INSERT INTO \"#{table_name}\" (#{table_col_str}) Values "+inserted_row_arr.join(', ')
                  inserted_row_arr=[]
                  result_set = ActiveRecord::Base.connection.execute(my_sql)
                end
              end              
            end
            total_record = row_id
          end          
          if chunk > 0
              chunk=0            
              my_sql="INSERT INTO \"#{table_name}\" (#{table_col_str}) Values "+inserted_row_arr.join(', ')
              inserted_row_arr=[]
              result_set = ActiveRecord::Base.connection.execute(my_sql)
          end
          error_record_count = error_row_num_list.size          
          total_record = total_record
          success_record = total_record - error_record_count
          user_table_mapping = UserFileMapping.where(:table_name => table_name.to_s).first
          if user_table_mapping then
            user_table_mapping.is_record_uploaded = true
            if success_record >= 0 then
              user_table_mapping.total_records = total_record
              user_table_mapping.success_records = success_record
              user_table_mapping.error_records = error_record_count
            end
            user_table_mapping.save
          end          
        rescue
          record_inserted_successfully = false
          raise ActiveRecord::Rollback
        end
      end 
      if record_inserted_successfully == false then
        user_table_mapping = UserFileMapping.where(:table_name => table_name.to_s).first
        if user_table_mapping then
          user_table_mapping.file_upload_status = Constant.file_upload_status_constants[:file_record_insert_error]
          user_table_mapping.save
        end
      end 
                  
    end
  end
  def self.get_table_data(table_name, page_size, page_index, column_name, order_type, search_value, column_arr)
    result = []
    begin
      sch_value=""
        if search_value!=""
          sch_value=sch_value+"WHERE"
          i=0
          column_arr.each do |column|           
            if i== 0
              sch_value=sch_value+" CAST( \"#{column}\" AS VARCHAR) LIKE '%#{search_value}%' "
            else
              sch_value=sch_value+" OR CAST(\"#{column}\" AS VARCHAR) LIKE '%#{search_value}%' "
            end         
           i=i+1
          end 
        end 
      my_sql="SELECT * FROM \"#{table_name}\" 
              CROSS JOIN ( SELECT Count(*) AS TotalRecord FROM \"#{table_name}\") AS tCountOrders 
              CROSS JOIN ( SELECT Count(*) AS FilterRecord FROM \"#{table_name}\" #{sch_value}) AS trecord  
              ORDER BY \"#{column_name}\" #{order_type} 
              OFFSET #{page_index} ROWS 
              FETCH NEXT #{page_size} ROWS ONLY;"            
      result = ActiveRecord::Base.connection.execute(my_sql)
      return result
    rescue Exception => err
      return result
    end
  end
  def self.get_table_data_without_pagination(table_name)
    result = []
    begin      
      my_sql="SELECT * FROM \"#{table_name}\"               "            
      result = ActiveRecord::Base.connection.execute(my_sql)
      return result
    rescue Exception => err
      return result
    end
  end
  def self.check_table_exist(table_name)
    result = []
    begin
      my_sql = "SELECT EXISTS(SELECT * FROM information_schema.tables WHERE table_name = '#{table_name}') as is_exist"
      result = ActiveRecord::Base.connection.execute(my_sql)
      return result
    rescue Exception => err
      return result
    end
  end
  def self.drop_table_if_exist(table_name)
    result = []
    begin
      my_sql = "DROP table \"#{table_name}\""
      result = ActiveRecord::Base.connection.execute(my_sql)
      return result
    rescue Exception => err
      return result
    end
  end
  def self.check_is_date_time(temp_arr, selected_date_format)
    begin
      is_data_time_format = temp_arr.collect{|val| DateTime.strptime(val, "#{selected_date_format} %H:%M:%S")}
      return "%H:%M:%S"
    rescue
      begin
        is_data_time_format = temp_arr.collect{|val| DateTime.strptime(val, "#{selected_date_format} %H:%M")}
        return "%H:%M"
      rescue        
        return ""
      end 
    end
  end
  def self.insert_error_detail(table_name, error_record_list)
    puts "Error record insert begin here......"
    begin
      target_bucket_name =  S3_ERROR_BUCKET_NAME
      target_file_name = "error" + table_name.to_s + ".csv"
      obj = target_bucket_name.objects.create(target_file_name, '')
      i = 0
      csv_string = CSV.generate do |csv|
        csv << ["row_id", "error_message", "error_record"]
        error_record_list.each do |error_record|  
          i = i + 1
          csv << [error_record[:row_id].to_s, error_record[:error].to_s, error_record[:error_record].to_s]    
          if i > 50 then
            read = obj.read + csv_string
            obj.write(read)
            csv_string=''
            i=0
          end   
        end
      end
      if i > 0 then
        read = obj.read + csv_string
        error_record_array = []
        obj.write(read)
      end
    rescue Exception => e
      puts e
    end    
  end
  def self.contain_blank_value(temp_row)
    #trim blank spaces at beginning and end
    temp_row = temp_row.collect{|x| if (x!=nil) then x.strip end}

    #removing blank, null and nil values from array
    temp_row = temp_row.reject { |c| c.blank? }
    # convert in downcase each value of array
    temp_row = temp_row.map(&:downcase)
    
    if ((temp_row.count("null") > 0) || (temp_row.count("nil") > 0)) then
      if ((temp_row.include? 'null') == true) then
        temp_row.delete("null")
      end
      if ((temp_row.include? 'nil') == true) then
        temp_row.delete("nil")
      end
    end
    if temp_row.size == 0 then
      return true
    else
      return false
    end
  end
  def self.delete_existing_data_source(table_name)
    is_process_complete = true
    ActiveRecord::Base.transaction do
      begin
        # 1.remove from user_file_mapping
        user_file_mapping_result = UserFileMapping.find_by(:table_name=>table_name.to_s)
        user_file_mapping_result.destroy

        #2. remove from table_error_records
        table_error_records_result = TableErrorRecord.where(:table_name => table_name.to_s)
        table_error_records_result.each do |result|
          result.destroy
        end

        #3. remove from user_table_column_informations
        user_table_column_informations_result = UserTableColumnInformation.where(:table_name => table_name.to_s)
        user_table_column_informations_result.each do |result|
          result.destroy
        end
        #4. remove from file_upload_error_messages
        file_upload_error_messages_result = FileUploadErrorMessage.where(:table_name => table_name.to_s)
        file_upload_error_messages_result.each do |result|
          result.destroy
        end
        #5. remove file from AWS s3
        #insert into a record user file mapping ....       
        bucket = S3_BUCKET      
        object = bucket.objects[table_name]
        object.delete
      rescue Exception => e
        is_process_complete = false
        raise ActiveRecord::Rollback
      end
    end
    return is_process_complete
  end
  def self.processing_on_single_row(row, columns_datatype_array)
    
    row.each_with_index do |value, value_index|
      data_type = ""
      # total count on column value
      columns_datatype_array[value_index][:total_counts] = columns_datatype_array[value_index][:total_counts] + 1;
      blank_value_arr = ['', 'nil',"NULL","",nil]
      if (blank_value_arr.include? value) == true
        if value != nil
            value = value.strip
        end
        columns_datatype_array[value_index][:nullable_counts] = columns_datatype_array[value_index][:nullable_counts] + 1;
      else
        # check value is an boolean or not
        if data_type == "" then
          begin
            bool_arr = ['true', '1', 'yes', 'on', 'false', '0', 'no', 'off', 0, 1]
            if (value.class.to_s) =="String"
              if (bool_arr.include? value.downcase) == true then
                columns_datatype_array[value_index][:boolean] = columns_datatype_array[value_index][:boolean] + 1;
                data_type="boolean"
              end
            else
              if (bool_arr.include? value) == true then
                columns_datatype_array[value_index][:boolean] = columns_datatype_array[value_index][:boolean] + 1;
                data_type="boolean"
              end
            end
          rescue
              # catch code at here
          end
        end
        # check value is an datetime 
        if data_type == "" then
          input_field_splitter_used = ''
          temp_val = value
          if (temp_val.include? '-') == true then
            input_field_splitter_used = '-'
          end
          if (temp_val.include? '/') == true then
            input_field_splitter_used = '/'
          end
          
          if input_field_splitter_used != ''
            if data_type == ""
              begin         
              temp_val = temp_val.tr("-/", ' ')
              temp_val = Date.strptime(temp_val, "%m %d %Y") 
              columns_datatype_array[value_index][:datetime] = columns_datatype_array[value_index][:datetime] + 1;
              data_type="datetime"         
              columns_datatype_array[value_index][:datetime_basic_info][:mdy_date_count]=columns_datatype_array[value_index][:datetime_basic_info][:mdy_date_count] +1
              rescue
                # catch code at here
              end
            end

            # check value is an datetime ( with  "%d %m %Y") !!
            if data_type == ""
              begin
                temp_val = temp_val.tr("-/", ' ')
                temp_val = Date.strptime(temp_val, "%d %m %Y") 
                columns_datatype_array[value_index][:datetime] = columns_datatype_array[value_index][:datetime] + 1;
                data_type="datetime"
                columns_datatype_array[value_index][:datetime_basic_info][:dmy_date_count]=columns_datatype_array[value_index][:datetime_basic_info][:dmy_date_count] +1
              
                #DataUploader.check_is_date_time(temp_val, "%m %d %Y")
              rescue
                # catch code at here
              end
            end

            # check value is an datetime ( with "%Y %m %d") !!
            if data_type == ""
              begin
                temp_val = temp_val.tr("-/", ' ')
                temp_val = Date.strptime(temp_val, "%Y %m %d") 
                columns_datatype_array[value_index][:datetime] = columns_datatype_array[value_index][:datetime] + 1;
                data_type="datetime"
                columns_datatype_array[value_index][:datetime_basic_info][:ymd_date_count]=columns_datatype_array[value_index][:datetime_basic_info][:ymd_date_count] +1
              
                #DataUploader.check_is_date_time(temp_val, "%m %d %Y")
              rescue
              # catch code at here
              end
            end
            
            # check value is an datetime ( with ""%Y %d %m"") !!
            if data_type == ""
              begin
                temp_val = temp_val.tr("-/", ' ')
                temp_val = Date.strptime(temp_val, "%Y %d %m") 
                columns_datatype_array[value_index][:datetime] = columns_datatype_array[value_index][:datetime] + 1;
                data_type = "datetime"
                columns_datatype_array[value_index][:datetime_basic_info][:ydm_date_count]=columns_datatype_array[value_index][:datetime_basic_info][:ydm_date_count] +1
                #DataUploader.check_is_date_time(temp_val, "%m %d %Y")
              rescue
                # catch code at here
              end
            end
          end
        end
        # check value is an integer ( also consider string if integer value with leading 0, for pincode or telephone numbers)
        if data_type == "" then
          begin
            temp_val = Integer(value)
            temp_arr =  Integer(value) == 0 ? "0" : value 
            is_string = false  
            # this code is write for check is this integer value can be a telephone or pincode numer 
            # so we are consider if any integer value with leading 0 value, will be a telephone or pincode numer 
            if value[0] == "0" && temp_arr != "0" then
              is_string = true
            end
            if is_string == true then
              columns_datatype_array[value_index][:string] = columns_datatype_array[value_index][:string] + 1; 
              data_type="string"
            elsif 
              columns_datatype_array[value_index][:integer] = columns_datatype_array[value_index][:integer] + 1; 
              data_type="integer"
            end                                  
          rescue
              # catch code at here
          end
        end
        # check value is an money format ( with leading and ending money symbols) 
        if data_type == "" then
          begin
            money_symbol = ''
            symbol_length = 0
            money_symbols = ['$','€','£','¥','Fr','kr','zł','Ft','Kč','A$','R$','RM','₱','NT$','฿', 'TRY', '₹']
            money_symbols.each do |symbol|
              symbol_length = symbol.size
              if (value[0...symbol_length][0] == symbol) then
                money_symbol = symbol
              break
              end
              if value[(value.size-symbol_length)...value.size][0] == symbol then
                money_symbol = symbol
                break
              end
            end
            if money_symbol != '' then
              temp_arr = value.tr(money_symbol, '').strip
              is_data_integer=Float(temp_arr.gsub(/,/,''))

              #max_length_after_decimal = (((temp_arr.map{|k| k.split('.')[1]}).reject { |c| c.blank? }).group_by(&:size).max.last)[0].size
              #max_length_before_decimal = (((temp_arr.map{|k| k.split('.')[0]}).reject { |c| c.blank? }).group_by(&:size).max.last)[0].size
              #column_detail[:field_length] = (max_length_before_decimal + max_length_after_decimal + 1).to_s + "," + max_length_after_decimal.to_s
              columns_datatype_array[value_index][:decimal] = columns_datatype_array[value_index][:decimal] + 1;
              data_type = "decimal" 
              columns_datatype_array[value_index][:money_percentage_basic_info].each do |money_percentage_format|
                if (money_percentage_format[:symbol] == money_symbol)
                  money_percentage_format[:count] = money_percentage_format[:count] + 1
                else
                  columns_datatype_array[value_index][:money_percentage_basic_info].append({symbol: money_symbol, count: 1 }) 
                end
              end
            end
          rescue
          end
        end
        # check value is an percentage/rate ( with last value will be a percentage symbol) type !!
        #byebug
        if data_type == "" then
          begin
            symbol_length = 1
            percent_symbols = ['%']
            is_percentage = false
            percent_symbols.each do |symbol|
              if value[0...symbol_length][0] == symbol then
                is_percentage = true
                break
              end
              if value[(value.size-symbol_length)...value.size][0] == symbol then
                is_percentage = true
                break
              end
            end
            if is_percentage == true then
              temp_arr = value.tr('%', '').strip
              is_an_float_value = Float(temp_arr.gsub(/,/,''))
              #max_length_after_decimal = (((temp_arr.map{|k| k.split('.')[1]}).reject { |c| c.blank? }).group_by(&:size).max.last)[0].size
              #max_length_before_decimal = (((temp_arr.map{|k| k.split('.')[0]}).reject { |c| c.blank? }).group_by(&:size).max.last)[0].size
              #column_detail[:field_length] = (max_length_before_decimal + max_length_after_decimal + 1).to_s + "," + max_length_after_decimal.to_s
              columns_datatype_array[value_index][:decimal] = columns_datatype_array[value_index][:decimal] + 1;
              data_type="decimal" 
              columns_datatype_array[value_index][:money_percentage_basic_info].each do |money_percentage_format|
                if (money_percentage_format[:symbol] == "%")
                money_percentage_format[:count] = money_percentage_format[:count] + 1
                end
              end
            end
          rescue
          end
        end

        if data_type == "" then
          begin
            temp_value = DateTime.parse(value)
            columns_datatype_array[value_index][:datetime] = columns_datatype_array[value_index][:datetime] + 1;
            data_type="datetime"
            #DataUploader.check_is_date_time(temp_val, "%m %d %Y")
          rescue
            #catch code at here
          end
        end
        # Check value is an float value !!
        if data_type == "" then
          begin
            is_an_float_value = Float(value)
            #max_length_after_decimal = (((csv_data[colindex].map{|k| k.split('.')[1]}).reject { |c| c.blank? }).group_by(&:size).max.last)[0].size
            #max_length_before_decimal = (((csv_data[colindex].map{|k| k.split('.')[0]}).reject { |c| c.blank? }).group_by(&:size).max.last)[0].size
            #column_detail[:field_length] = (max_length_before_decimal + max_length_after_decimal + 1).to_s + "," + max_length_after_decimal.to_s
            columns_datatype_array[value_index][:decimal] = columns_datatype_array[value_index][:decimal] + 1;
            data_type="decimal" 
          rescue
            # catch code at here
          end
        end
        # Check value is an time value !!
        if data_type == "datetime" then
          begin
          # ForHH:MM:SS
            if (!!(val =~ /^(0?[1-9]|1[012])(:[0-5]\d)(:[0-5]\d)$/) == true ) then
              columns_datatype_array[value_index][:time] = columns_datatype_array[value_index][:time] + 1;
              data_type = "time" 
            end
          rescue
            # catch code at here
          end
          # only for HH:MM 
          if data_type != "time" then 
            begin
              # For HH:MM
              if (!!(val =~ /^(0?[1-9]|1[012])(:[0-5]\d)$/) == true ) then
                columns_datatype_array[value_index][:time] = columns_datatype_array[value_index][:time] + 1;
                data_type = "time" 
              end
            rescue
              # catch code at here
            end
          end
          # only for HH:MM:SS  AM/PM
          if data_type != "time" then 
            begin
              if (!!(val =~ /^(0?[1-9]|1[012])(:[0-5]\d)(:[0-5]\d) [APap][mM]$/) == true ) then
                columns_datatype_array[value_index][:time] = columns_datatype_array[value_index][:time] + 1;
                data_type = "time"
              end
            rescue
              # catch code at here
            end
          end
          # only for HH:MM  AM/PM
          if data_type != "time" then 
            begin
              # ForHH:MM
              if (!!(val =~ /^(0?[1-9]|1[012])(:[0-5]\d) [APap][mM]$/) == true ) then
                columns_datatype_array[value_index][:time] = columns_datatype_array[value_index][:time] + 1;
                data_type = "time"
              end
            rescue
              # catch code at here
            end
          end
        end
        # Check value is an string value !!
        if data_type == "" then
          begin
            is_data_integer = String(value)
            columns_datatype_array[value_index][:string] = columns_datatype_array[value_index][:string] + 1;
            data_type = "string"
          rescue
            # catch code at here
          end
        end
      end
    end
  end
  def self.find_maximum_counts_datatype(column_detail_value)
   
    maximum_counts_datatype = {data_type: '', count: 0 }
    lst_of_data_types =[{data_type: 'time', count:column_detail_value[:time] },
                        {data_type: 'decimal', count:column_detail_value[:decimal] },
                        {data_type: 'datetime', count:column_detail_value[:datetime] },
                        {data_type: 'integer', count:column_detail_value[:integer] },
                        {data_type: 'boolean', count:column_detail_value[:boolean] },
                        {data_type: 'string', count:column_detail_value[:string] },
                        ]
    max_count = 0
    data_type =''
    lst_of_data_types.each do |type_obj|
      if max_count < type_obj[:count]
        max_count = type_obj[:count]
        data_type = type_obj[:data_type]
      end
    end
    maximum_counts_datatype[:data_type] = data_type
    maximum_counts_datatype[:count] = max_count
    
    return maximum_counts_datatype
  end
  def self.create_dynamic_table_for_row_wise_read(table_name, column_structure_object)
    begin
      if column_structure_object.size > 0
        ActiveRecord::Schema.define do
          create_table "#{table_name}", :id => false do |t|
            column_structure_object.each do |column_struct|
              is_nullable = (column_struct[:nullable_counts] > 0 ? true : false)
              puts is_nullable
              if (column_struct[:data_type] == '')
                column_struct[:data_type] ='string'
              end
              case column_struct[:data_type]
                when 'boolean'
                  t.column column_struct[:columns_name], column_struct[:data_type], null: is_nullable
                when 'decimal'
                  t.column column_struct[:columns_name], column_struct[:data_type], null: is_nullable
                when 'datetime'
                  t.column column_struct[:columns_name], column_struct[:data_type], null: is_nullable
                when 'time'
                  t.column column_struct[:columns_name], column_struct[:data_type], null: is_nullable               
                when 'integer'
                  t.column column_struct[:columns_name], column_struct[:data_type], null: is_nullable
                else
                  t.column column_struct[:columns_name], column_struct[:data_type], null: is_nullable
              end
            end
          end
        end
      end
      return true
    rescue Exception => err
      return err.message
    end
  end
  def self.insert_csv_data_for_row_wise_read(csv_file_data, table_name, column_structure_object, error_row_num_list, error_record_list)
    if column_structure_object.size > 0
      table_col_str = column_structure_object.map{|col| "\"#{col[:columns_name]}\""}.join(', ')
      total_record = 0
      error_record_count = 0
      success_record = 0
      chunk = 0
      inserted_row_arr=[]
      record_inserted_successfully = true
      puts "step 1"
      ActiveRecord::Base.transaction do
        begin
          CSV.parse(csv_file_data).each_with_index do |row, row_id|             
            if row_id > 0
              puts "step 2"
              if !(error_row_num_list.include? row_id) 
                inserted_row_string = []
                row.each_with_index do |inserted_row_value,col_index|
                  begin
                    if inserted_row_value == nil then
                      inserted_row_string.append('NULL')
                    elsif ((inserted_row_value.to_s.strip.downcase == 'null') || (inserted_row_value.to_s.strip.downcase) == "nil" || (inserted_row_value.to_s.strip == "")) then
                       inserted_row_string.append('NULL')
                    else
                      case column_structure_object[col_index][:data_type]
                      when "datetime"
                        begin
                          if column_structure_object[col_index][:date_format] != "" then
                            #byebug
                            inserted_row_string.append(DateTime.strptime(inserted_row_value.tr("-/", ' ').strip, column_structure_object[col_index][:date_format]).strftime("%Y-%m-%d %H:%M:%S").to_s )
                          else
                            inserted_row_string.append(DateTime.parse(inserted_row_value.strip).strftime("%Y-%m-%d %H:%M:%S").to_s )
                          end
                        rescue Exception => err
                          inserted_row_string = []
                          error_record_list.append({:row_id => row_id+1, :error => "Record cannot be inserted due to different data type value", :error_record => row.to_a})
                          break
                        end
                      when "integer"
                        begin                          
                          inserted_row_string.append(Integer(inserted_row_value).to_i.to_s)
                        rescue Exception => e
                          inserted_row_string = []
                          error_record_list.append({:row_id => row_id+1, :error => "Record cannot be inserted due to different data type value", :error_record => row.to_a})
                          break
                        end
                      when "decimal"
                        begin
                          if column_structure_object[col_index][:symbol]== ''
                            is_Float = Float(inserted_row_value)
                            inserted_row_string.append(inserted_row_value.to_f.to_s)
                          elsif column_structure_object[col_index][:symbol] == '%'
                            inserted_row_value = inserted_row_value.to_s.tr('%','').strip
                            is_Float = Float(inserted_row_value.gsub(/,/,''))
                            inserted_row_string.append(inserted_row_value.gsub(/,/,'').to_f.to_s)
                          else                          
                            inserted_row_value = inserted_row_value.to_s.tr(column_structure_object[col_index][:symbol],'').strip
                            is_Float = Float(inserted_row_value.gsub(/,/,''))
                            inserted_row_string.append(inserted_row_value.gsub(/,/,'').to_f.to_s)
                          end
                        rescue Exception => e
                           inserted_row_string = []
                          error_record_list.append({:row_id => row_id+1, :error => "Record cannot be inserted due to different data type value", :error_record => row.to_a})
                          break
                        end
                      when "time"
                        begin
                          inserted_row_string.append((inserted_row_value.strip.to_time).to_s) 
                        rescue
                          inserted_row_string = []
                          error_record_list.append({:row_id => row_id+1, :error => "Record cannot be inserted due to different data type value", :error_record => row.to_a})
                          break
                        end
                      when "string"
                          inserted_row_string.append(inserted_row_value.to_s) 
                      when "boolean"
                        begin
                          true_values_arr =[true,'true','on',1,'1']
                          is_it_boolean =false
                          if true_values_arr.include? inserted_row_value.downcase
                            is_it_boolean= true
                            inserted_row_string.append(true.to_s) 
                          end
                          false_values_arr =[false,'false','off',0,'0']
                          if false_values_arr.include? inserted_row_value.downcase
                            is_it_boolean =true
                            inserted_row_string.append(false.to_s) 
                          end
                          if (is_it_boolean==false)
                            inserted_row_string = []
                            error_record_list.append({:row_id => row_id+1, :error => "Record cannot be inserted due to different data type value", :error_record => row.to_a})
                          break
                          end
                        rescue Exception => e
                        end
                      end
                    end
                  rescue  Exception => err
                    puts err.message
                    record_inserted_successfully = false
                    raise ActiveRecord::Rollback                    
                  end                         
                end             
                if(inserted_row_string.size > 0)
                  values = '('+ ((inserted_row_string.map{|val| val=="NULL" ? "#{val}": "\'#{val}\'"}.join(', ')).to_s) + ')'
                  puts "++++++++++++++++++++++++ Insert Row ++++++++++++++++++++++++++++"
                  puts values            
                  inserted_row_arr.append(values)                                     
                end                        
                chunk=chunk + 1           
                if chunk > 50 then
                  chunk=0
                  my_sql="INSERT INTO \"#{table_name}\" (#{table_col_str}) Values "+inserted_row_arr.join(', ')
                  inserted_row_arr=[]
                  result_set = ActiveRecord::Base.connection.execute(my_sql)
                end
              end              
            end
            total_record = row_id
          end          
          if (chunk > 0 && inserted_row_arr.size > 0)
              chunk=0            
              my_sql="INSERT INTO \"#{table_name}\" (#{table_col_str}) Values "+inserted_row_arr.join(', ')
              inserted_row_arr=[]
              result_set = ActiveRecord::Base.connection.execute(my_sql)
          end
          error_record_count = error_row_num_list.size          
          total_record = total_record
          success_record = total_record - error_record_count
          user_table_mapping = UserFileMapping.where(:table_name => table_name.to_s).first
          if user_table_mapping then
            user_table_mapping.is_record_uploaded = true
            if success_record >= 0 then
              user_table_mapping.total_records = total_record
              user_table_mapping.success_records = success_record
              user_table_mapping.error_records = error_record_count
            end
            user_table_mapping.save
          end          
        rescue  Exception => err
          record_inserted_successfully = false
          puts err.message
          raise ActiveRecord::Rollback
        end
      end 
      if record_inserted_successfully == false then
        user_table_mapping = UserFileMapping.where(:table_name => table_name.to_s).first
        if user_table_mapping then
          user_table_mapping.file_upload_status = Constant.file_upload_status_constants[:file_record_insert_error]
          user_table_mapping.save
        end
      end 
                  
    end
  end
  def self.find_money_format_if_exist(column_detail_value)
    max_count=0
    symbol=''
    column_detail_value[:money_percentage_basic_info].each do |format_array|
      if format_array[:count] > max_count
        max_count = format_array[:count]
        symbol = format_array[:symbol]
      end
    end
    return symbol
  end
  def self.find_datetime_format_if_exist(column_detail_value)
    date_format=''
    dmy_count = column_detail_value[:datetime_basic_info][:dmy_date_count]
    mdy_count = column_detail_value[:datetime_basic_info][:mdy_date_count]
    ymd_count = column_detail_value[:datetime_basic_info][:ymd_date_count]
    ydm_count = column_detail_value[:datetime_basic_info][:ydm_date_count]
    if dmy_count == 0 && mdy_count == 0 && ymd_count == 0 && ydm_count == 0
      date_format =''
    elsif(dmy_count > mdy_count)
     if(dmy_count > ymd_count)
        if(dmy_count > ydm_count)
          date_format = '%d %m %Y'
        else
          date_format = '%Y %d %m'
        end
      end
    elsif(mdy_count > ymd_count)
      if(mdy_count  > ydm_count)
        date_format = '%m %d %Y'
      else
        date_format = '%Y %d %m'
      end
    elsif(ymd_count > ydm_count)
        date_format = '%Y %m %d'
    else
        date_format = '%Y %d %m'
    end
    return date_format
  end
end
