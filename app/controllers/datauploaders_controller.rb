class DatauploadersController < ApplicationController
  before_action :set_datauploader, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @datauploaders = Datauploader.all
    respond_with(@datauploaders)
  end

  def show
    respond_with(@datauploader)
  end

  def new
    @datauploader = Datauploader.new    
    respond_with(@datauploader)
  end

  def edit
  end

  def create
    @datauploader = Datauploader.new(datauploader_params)
    @datauploader.save
    respond_with(@datauploader)
  end

  def update
    @datauploader.update(datauploader_params)
    respond_with(@datauploader)
  end

  def destroy
    @datauploader.destroy
    respond_with(@datauploader)
  end
  
  def import
    if params[:file] then
      countTableName = Userfilemapping.where("tablename LIKE :prefix", prefix: "#{params[:file].original_filename.split('.').first}%").count
      tableName = countTableName > 0? params[:file].original_filename.split('.').first + "#{countTableName}" : params[:file].original_filename.split('.').first
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
          #value_list = line.split(',')             
          #ql = "INSERT INTO #{tableName.downcase.pluralize} ('column1', `column2`, 'column3', `column4`) VALUES (#{value_list.map {|rec| "'#{rec}'" }.join(", ")})"
          #AciveRecord::Base.connection.execute(sql)
        end     
          
        i = 0;
        columnName = ""
        @columnsDetail = []     
        columns = csvData.shift
        csvData = csvData.transpose
        columns.each do |column|
          j = i+1;
          if (column == nil) then            
            column = "column" + j.to_s;
          else
            column = column.strip
            column = column.tr(" ", '')
            
            column = column.downcase                
            
            if ((column == "null") || (column == "nil") || (column == "")) then 
              column = "column" + j.to_s;
            end
                        
            column.gsub(/[^0-9A-Za-z]/, '')
          end       
          columnDetail = {columnName: column,
                  isNullable: false,
                  dataType: "",
                  fieldLength: "0",
                  isUnique: true}          
                                           
          #trim blank spaces at begining and end
          csvData[i] = csvData[i].collect{|x| if (x!=nil) then x.strip end}
          #byebug
        
          if ((csvData[i].count(nil) > 1) || (csvData[i].count("") > 1)) then
            columnDetail[:isUnique] = false
          end
          
          if ((csvData[i].count(nil) > 0) || (csvData[i].count("") > 0)) then            
            columnDetail[:isNullable] = true            
          end
          
          #removing blank, null and nil values from array
          csvData[i] = csvData[i].reject { |c| c.blank? }
                   
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
              if (((csvData[i].collect{|v| v.include? '-'}).uniq).include? false)==false then
                isDateTime = true
              end
          
              if (((csvData[i].collect{|v| v.include? '/'}).uniq).include? false) ==false then
                isDateTime = true
              end
          
              if isDateTime then
                tempArr = csvData[i].collect{|x| x.tr("-/", ' ')}
                # Check array containing date values only
                if columnDetail[:dataType]=="" then
                  begin
                    isDataInteger=tempArr.collect{|val| Date.strptime(val, "%m %d %Y")}
                    columnDetail[:dataType] = "datetime"
                  rescue
                    # catch code at here
                  end
                end
            
                # Check array containing date values only
                if columnDetail[:dataType]=="" then
                  begin
                    isDataInteger=tempArr.collect{|val| Date.strptime(val, "%d %m %Y")}
                    columnDetail[:dataType] = "datetime"
                  rescue
                  # catch code at here
                  end
                end
            
                # Check array containing date values only
                if columnDetail[:dataType]=="" then
                  begin
                    isDataInteger=tempArr.collect{|val| Date.strptime(val, "%Y %m %d")}
                    columnDetail[:dataType] = "datetime"
                  rescue
                    # catch code at here
                  end
                end
            
                # Check array containing date values only
                if columnDetail[:dataType]=="" then
                  begin
                    isDataInteger=tempArr.collect{|val| Date.strptime(val, "%Y %d %m")}
                    columnDetail[:dataType] = "datetime"
                  rescue
                    # catch code at here
                  end
                end
            
                # Check array containing date values only
                if columnDetail[:dataType]=="" then
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
        #puts  @columnsDetail
        create_dynamic_table(tableName.downcase.pluralize, @columnsDetail)
        redirect_to new_datauploader_path, notice: "Data Uploaded Successfully"
      end      
    else
      redirect_to new_datauploader_path, :flash => { :error => "Please select a file to upload data." }
    end
  end
  
  def create_dynamic_table(table_name, columnStructureObject)
    begin
      if columnStructureObject.size > 0 then        
        ActiveRecord::Schema.define do
          create_table "#{table_name}" do | t |
            columnStructureObject.each do |columnStruct|
              case columnStruct[:dataType]
              when "boolean"
                t.column columnStruct[:columnName], columnStruct[:dataType], null: columnStruct[:isNullable]
              when "decimal"
                t.column columnStruct[:columnName], columnStruct[:dataType], null: columnStruct[:isNullable], precision: (columnStruct[:fieldLength].split(',')[0]).to_i, scale: (columnStruct[:fieldLength].split(',')[1]).to_i
              when "datetime"
                t.column columnStruct[:columnName], columnStruct[:dataType], null: columnStruct[:isNullable]             
              else
                t.column columnStruct[:columnName], columnStruct[:dataType], null: columnStruct[:isNullable], limit: columnStruct[:fieldLength], uniq: columnStruct[:isUnique]
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

  private
    def set_datauploader
      @datauploader = Datauploader.find(params[:id])
    end

    def datauploader_params
      params[:datauploader]
    end
end
