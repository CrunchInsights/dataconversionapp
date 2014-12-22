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
             #ActiveRecord::Base.connection.execute(sql)
          end     
          
          i = 0;
          columnName = ""
          @columnsDetail = []     
          columns = csvData.shift
          csvData = csvData.transpose          
          columns.each do |column|
            columnDetail = {columnName: column,
                            isNullable: false,
                            dataType: "",
                            fieldLength: 0,
                            isUnique: false}
                            
          #trim blank spaces at begining and end
          csvData[i] = csvData[i].collect{|x| x.strip}
          
          #check nullable feild  
          if csvData[i].include? '' then
            columnDetail[:isNullable] = true
          end                   
          
          #check value containing null values
          if !columnDetail[:isNullable] then
            #check nullability of column
            if csvData[i].map(&:downcase).include? 'null' then
              columnDetail[:isNullable] = true
            end            
          end
          
          #check value containing nil values
          if !columnDetail[:isNullable] then
            #check nullability of column
            if csvData[i].map(&:downcase).include? 'nil' then
              columnDetail[:isNullable] = true
            end            
          end
          
          #removing blank, null and nil values from array                   
          csvData[i] = csvData[i].map(&:downcase).reject! { |c| c.blank? }
          csvData[i] = csvData[i].map(&:downcase).delete("null")
          
          
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
              columnDetail[:dataType] = "decimal"
            rescue
              # catch code at here
            end
         end
         
         # Check array containing string values
         if columnDetail[:dataType]=="" then
          begin
            isDataInteger=csvData[i].collect{|val| String(val)}
            columnDetail[:dataType] = "varchar"
          rescue
            # catch code at here
          end
         end
             
            
         @columnsDetail.append(columnDetail)
         i=i+1                         
          end
                              puts  @columnsDetail
          redirect_to new_datauploader_path, notice: "Data Uploaded Successfully"
      end      
    else
      redirect_to new_datauploader_path, :flash => { :error => "Please select a file to upload data." }
    end
  end
  
  def create_dynamic_table(table_name)
    begin
      ActiveRecord::Schema.define do
        create_table "#{table_name}" do | t |
          t.column :column1,   :string
          t.column :column2,       :string
          t.column :column3,      :string
          t.column :column4,      :string
          #t.column :phone1,     :string
          #t.column :phone2,     :string
          #t.column :phone3,     :string
          #t.column :phonedesc1, :string
          #t.column :phonedesc2, :string
          #t.column :phonedesc3, :string
          #t.column :timezone,   :string
          #t.column :comments,   :string
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
