class DatauploadersController < ApplicationController
  respond_to :html
  def import
    if params[:file] then
      countTableName = Userfilemapping.where("tablename LIKE ? OR tablename LIKE ?", "#{(params[:file].original_filename.split('.').first).tr(" ","")}%", "#{(params[:file].original_filename.split('.').first.pluralize).tr(" ","")}%").count
      tableName = countTableName > 0? params[:file].original_filename.split('.').first + "#{countTableName}" : params[:file].original_filename.split('.').first
      tableName=tableName.tr(" ","")
      addFileDetail =  Userfilemapping.create(
                user: current_user,
                filename: params[:file].original_filename,
                tablename: tableName.downcase.pluralize,
                created_by: current_user.id,
                created_on: Time.now,
                modified_by: current_user.id,
                modified_on: Time.now)
      if addFileDetail.errors.any?
        errors = ""
        addFileDetail.errors.full_messages.each do |message|
          errors = errors + message + "\n"
        end         
        redirect_to new_datauploader_path, :flash => { :error => errors }
      else
        csvData = []
          CSV.foreach(params[:file].path) do |row|
            csvData.append(row.to_a)
          end
        i = 0
        columnName = ''
        @columnsDetail = []
        columns = csvData.shift

        if columns.size != columns.uniq.size  then
          redirect_to new_datauploader_path, :flash => { :error => 'In uploaded file columns are repeated' }
        else
          csvData = csvData.transpose
          columns.each do |column|
            j = i+1;
            if (column == nil) then
              column = 'column' + j.to_s;
            else
              column = column.strip
              column = column.tr(' ', '')

              column = column.downcase

              if ((column == "null") || (column == "nil") || (column == "")) then
                column = "column" + j.to_s;
              end

              column.gsub(/[^0-9A-Za-z]/, '')
            end
            columnDetail = {columnName: column,
                            isNullable: false,
                            dataType: "",
                            dateformat:"",
                            fieldLength: "0",
                            moneySymbol: "",
                            isMoneyFormat: false,
                            moneySymbolPosition: "",
                            isUnique: true}

            #trim blank spaces at beginning and end
            csvData[i] = csvData[i].collect{|x| if (x!=nil) then x.strip end}

            # check column contain more than 1 value of nil and blank
            if ((csvData[i].count(nil) > 1) || (csvData[i].count("") > 1)) then
              columnDetail[:isUnique] = false
            end

            if ((csvData[i].count(nil) > 0) || (csvData[i].count("") > 0)) then
              columnDetail[:isNullable] = true
            end

            #removing blank, null and nil values from array
            csvData[i] = csvData[i].reject { |c| c.blank? }
            # convert in downcase each value of array
            csvData[i] = csvData[i].map(&:downcase)

            if ((csvData[i].count("null") > 1) && (columnDetail[:isUnique] == true))then
              columnDetail[:isUnique] = false
            end

            if ((csvData[i].count("null") > 0) || (csvData[i].count("nil") > 0)) then
              columnDetail[:isNullable] = true
              if ((csvData[i].include? 'null') == true) then
                csvData[i].delete("null")
              end
              if ((csvData[i].include? 'nil') == true) then
                csvData[i].delete("nil")
              end
            end

            if columnDetail[:isUnique] then
              if csvData[i].size == csvData[i].uniq.size  then
                columnDetail[:isUnique] = true
              else
                columnDetail[:isUnique] = false
              end
            end

            if csvData[i].size == 0 then
              columnDetail[:dataType] = "string"
              columnDetail[:fieldLength] = "10"
            else
              if csvData[i].size > 0 then
                boolArr = ['true', '1', 'yes', 'on', 'false', '0', 'no', 'off', 0, 1]

                # Check array containing integer values only
                if columnDetail[:dataType]=="" then
                  begin
                    if (csvData[i] - boolArr).empty? then
                      columnDetail[:dataType] = "boolean"
                    end
                  rescue
                    # catch code at here
                  end
                end
                isDateTime = false
                inputFieldSplitterUsed = ''
                if (((csvData[i].collect{|v| v.include? '-'}).uniq).include? false)== false then
                  inputFieldSplitterUsed = '-'
                  isDateTime = true
                end

                if (((csvData[i].collect{|v| v.include? '/'}).uniq).include? false) == false then
                  inputFieldSplitterUsed = '/'
                  isDateTime = true
                end

                if isDateTime then
                  tempArr = csvData[i].collect{|x| x.tr("-/", ' ')}
                  # Check array containing date values only
                  if columnDetail[:dataType] == "" then
                    begin
                      isDataInteger=tempArr.collect{|val| Date.strptime(val, "%m %d %Y")}
                      columnDetail[:dataType] = "datetime"
                      columnDetail[:dateformat] = "%m" + inputFieldSplitterUsed + "%d" + inputFieldSplitterUsed + "%Y"
                    rescue
                      # catch code at here
                    end
                  end

                  # Check array containing date values only
                  if columnDetail[:dataType] == "" then
                    begin
                      isDataInteger=tempArr.collect{|val| Date.strptime(val, "%d %m %Y")}
                      columnDetail[:dataType] = "datetime"
                      columnDetail[:dateformat] = "%d" + inputFieldSplitterUsed + "%m" + inputFieldSplitterUsed + "%Y"
                    rescue
                      # catch code at here
                    end
                  end

                  # Check array containing date values only
                  if columnDetail[:dataType] == "" then
                    begin
                      isDataInteger=tempArr.collect{|val| Date.strptime(val, "%Y %m %d")}
                      columnDetail[:dataType] = "datetime"
                      columnDetail[:dateformat]="%Y" + inputFieldSplitterUsed +  "%m" + inputFieldSplitterUsed + "%d"
                    rescue
                      # catch code at here
                    end
                  end

                  # Check array containing date values only
                  if columnDetail[:dataType] == "" then
                    begin
                      isDataInteger=tempArr.collect{|val| Date.strptime(val, "%Y %d %m")}
                      columnDetail[:dataType] = "datetime"
                      columnDetail[:dateformat] = "%Y" + inputFieldSplitterUsed +  "%d" + inputFieldSplitterUsed + "%m"
                    rescue
                      # catch code at here
                    end
                  end

                  # Check array containing date values only
                  if columnDetail[:dataType] == "" then
                    begin
                      isDataInteger=csvData[i].collect{|val| DateTime.parse(val)}
                      columnDetail[:dataType] = "datetime"
                    rescue
                      # catch code at here
                    end
                  end
                end

                # Check array containing integer values only
                if columnDetail[:dataType]=="" then
                  begin
                    isDataInteger=csvData[i].collect{|val| Integer(val)}
                    columnDetail[:dataType] = "integer"
                  rescue
                    # catch code at here
                  end
                end

                # check array containing money format
                if columnDetail[:dataType]=="" then
                  begin
                    moneySymbol = ''
                    symbolLength = 0
                    #byebug
                    money_symbols = ['$','€','£','¥','Fr','kr','zł','Ft','Kč','A$','R$','RM','₱','NT$','฿', 'TRY', '₹']
                    money_symbols.each do |symbol|
                      symbolLength = symbol.size

                      if (csvData[i].collect{|k| k[0...symbolLength]}.uniq)[0] == symbol then
                        moneySymbol = symbol
                        columnDetail[:isMoneyFormat] = true
                        columnDetail[:moneySymbolPosition] = "start"
                        break
                      end
                      if (csvData[i].collect{|k| k[(k.size-symbolLength)...k.size]}.uniq)[0] == symbol then
                        moneySymbol = symbol
                        columnDetail[:isMoneyFormat] = true
                        columnDetail[:moneySymbolPosition] = "end"
                        break
                      end
                    end
                    if moneySymbol != '' then
                      tempArr = csvData[i].collect{|x| x.tr(moneySymbol, '').strip}
                      isDataInteger=tempArr.collect{|val| Float(val.gsub(/,/,''))}
                      maxLengthAfterDecimal = (((tempArr.map{|k| k.split('.')[1]}).reject { |c| c.blank? }).group_by(&:size).max.last)[0].size
                      maxLengthBeforeDecimal = (((tempArr.map{|k| k.split('.')[0]}).reject { |c| c.blank? }).group_by(&:size).max.last)[0].size
                      columnDetail[:fieldLength] = (maxLengthBeforeDecimal + maxLengthAfterDecimal + 1).to_s + "," + maxLengthAfterDecimal.to_s
                      columnDetail[:dataType] = "decimal"
                      columnDetail[:moneySymbol] = moneySymbol
                    end
                  rescue
                    # catch code at here
                  end
                end

                # Check array containing float values only
                if columnDetail[:dataType]=="" then
                  begin
                    isDataInteger=csvData[i].collect{|val| Float(val)}
                    maxLengthAfterDecimal = (((csvData[i].map{|k| k.split('.')[1]}).reject { |c| c.blank? }).group_by(&:size).max.last)[0].size
                    maxLengthBeforeDecimal = (((csvData[i].map{|k| k.split('.')[0]}).reject { |c| c.blank? }).group_by(&:size).max.last)[0].size
                    columnDetail[:fieldLength] = (maxLengthBeforeDecimal + maxLengthAfterDecimal + 1).to_s + "," + maxLengthAfterDecimal.to_s
                    columnDetail[:dataType] = "decimal"
                  rescue
                    # catch code at here
                  end
                end

                # Check array containing string values
                if columnDetail[:dataType]=="" then
                  begin
                    isDataInteger=csvData[i].collect{|val| String(val)}
                    columnDetail[:dataType] = "string"
                  rescue
                    # catch code at here
                  end
                end
                if columnDetail[:dataType]!= "decimal" then
                  columnDetail[:fieldLength] = ((csvData[i].group_by(&:size).max.last)[0].size) + 1
                end
              end
            end
            @columnsDetail.append(columnDetail)
            i=i+1
          end
          isTableCreated = Datauploader.create_dynamic_table(tableName.downcase.pluralize, @columnsDetail)
          if isTableCreated
            begin
              @columnsDetail.each do |column|
                if column[:isMoneyFormat]==true
                  updateColumnInfo=Usertablecolumninformation.create(
                      tablename: tableName.downcase.pluralize,
                      columnname: column[:columnName],
                      moneyformat:  column[:moneySymbol],
                      isdisable: false,
                      created_by: current_user.id,
                      created_on: Time.now ,
                      modified_by: current_user.id,
                      modified_on: Time.now)
                end
              end
            rescue
            end
            Datauploader.insertCsvData(params[:file].path, tableName.downcase.pluralize, @columnsDetail)
            redirect_to showuploadedschema_datauploaders_path({:tableName => tableName.downcase.pluralize}), notice: "Data Uploaded Successfully"
          else
            redirect_to new_datauploader_path, :flash => { :error => "Error: #{isTableCreated}" }
          end
        end
      end
    else
      redirect_to new_datauploader_path, :flash => { :error => "Please select a file to upload data." }
    end
  end

  # show upload csv generated table schema
  def showuploadedschema
    @tableName = params[:tableName]
    @uploadedSchema = Datauploader.getUploadedSchema(@tableName)
    if @uploadedSchema.size>0
      @disabledColumn = get_usertablecolumninfo(@tableName)
    else
      redirect_to uploadedfile_datauploaders_path, :flash => { :error => "Table schema not exists" }
    end
  end

  # find uploaded files details
  def uploadedfile
    currentUser = current_user.id
    @uploadedFiles = Userfilemapping.where(:user_id =>currentUser )
    respond_with(@uploadedFiles)
  end

  # find uploaded file records
  def uploadfilerecord
    @tableRecord={columns:[], records:[] }
    @uploadedRecords=[]
    tableName = params[:tableName]
    @uploadedSchema = Datauploader.getUploadedSchema(tableName)
    if @uploadedSchema.size>0
      my_sql="SELECT * FROM #{tableName}"
      resultRecords = ActiveRecord::Base.connection.execute(my_sql)
      if resultRecords.size > 0 then

        disabledColumn = get_usertablecolumninfo(tableName)
        @uploadedSchema.each do |sehema|
          @tableRecord[:columns].append({columnname: sehema[:Field],isdisable: (disabledColumn.include?sehema[:Field]) })
        end
        resultRecords.each do |result|
          @tableRecord[:records].append(result)
        end

      end
      respond_with(@uploadedRecords,@uploadedSchema,@tableRecord)
    else
      redirect_to uploadedfile_datauploaders_path, :flash => { :error => "Table schema not exists" }
    end

  end

  def changetablecolumndetail
    @uploadedRecords=[]
    respond_with(@uploadedRecords)
  end

  def columnexculdeinculde
    tableName = params[:tableName]
    columnName = params[:columnName]
    isColumnDisabled = params[:isColumnDisabled]
    errors = ""
    updateColumnInfo = Usertablecolumninformation.where("tablename =? AND columnname = ?", tableName, columnName).first
    if updateColumnInfo then
      updateColumnInfo.isdisable = isColumnDisabled
      updateColumnInfo.save
    else
      updateColumnInfo=Usertablecolumninformation.create(
          tablename: tableName,
          columnname: columnName,
          moneyformat:  '',
          isdisable: isColumnDisabled,
          created_by: current_user.id,
          created_on: Time.now ,
          modified_by: current_user.id,
          modified_on: Time.now)
    end

    if updateColumnInfo.errors.any?
      updateColumnInfo.errors.full_messages.each do |message|
        errors = errors + message + "\n"
      end
    end

    respond_to do |format|
      format.html { redirect_to showuploadedschema_datauploaders_path({:tableName => tableName}), notice: (errors.size ==0 ? "Column detail update Successfully":errors)  }
      format.json { head :no_content }
    end

  end

  private
    def get_usertablecolumninfo(tableName)
      tableColumnInfo = Usertablecolumninformation.where("tablename =? and isdisable =?", tableName, 1)
      disabledColumn=[]
      if tableColumnInfo.size > 0 then
        tableColumnInfo.each do |column|
          disabledColumn.append(column.columnname)
        end
      end
      return disabledColumn
    end
end
