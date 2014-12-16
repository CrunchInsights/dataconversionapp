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

      addFileDetail =  Userfilemapping.create(
                          user: current_user,
                          filename: params[:file].original_filename,
                          tablename: countTableName > 0? params[:file].original_filename.split('.').first + "#{countTableName}" : params[:file].original_filename.split('.').first,
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
          redirect_to new_datauploader_path, notice: "Data Uploaded Successfully"
      end      
    else
      redirect_to new_datauploader_path, :flash => { :error => "Please select a file to upload data." }
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
