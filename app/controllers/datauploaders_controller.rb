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
          #create_dynamic_table(tableName.downcase.pluralize)
          #schema = DrNicMagicModels::Schema.new(Object)
          #DrNicMagicModels::Schema.class_eval "@@models = nil" 
          #DrNicMagicModels::Schema.load_schema
          #DrNicMagicModels::Schema.class_eval "puts @@models.inspect"
          csvData = []
          i = 0;
          columnName = ""
          columnsDetail = []
          CSV.foreach(params[:file].path) do |row|                  
             csvData.append(row.to_a)
             #value_list = line.split(',')             
             #ql = "INSERT INTO #{tableName.downcase.pluralize} ('column1', `column2`, 'column3', `column4`) VALUES (#{value_list.map {|rec| "'#{rec}'" }.join(", ")})"
             #ActiveRecord::Base.connection.execute(sql)
          end          
          columns = csvData.shift
          csvData = csvData.transpose          
          columns.each do |column|          
            columnDetail = {columnName: column,
                            isNullable: false,
                            dataType: "string",
                            fieldLength: 0,
                            isUnique: false}
            
            if csvData[i].collect{|x| x.strip}.include? '' then
              columnDetail.isNullable = true
            end
            if !(columnDetail.isNullable) then
              #check nullability of column
              if csvData[i].map(&:downcase).include? 'null' then
                columnDetail.isNullable = true
              end            
            end
            
            if csvData[i].all?{|arr_value| arr_value.is_a? Integer}
                            
            end
            
            if csvData[i].all?{|arr_value| arr_value.is_a? String}
              
            end
                                       
          end
                                  
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
