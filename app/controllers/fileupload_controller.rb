class FileuploadController < ApplicationController
  def upload 
     render :file => 'app\views\fileupload\upload.html.erb'   
  end
   def uploadFile
    post = DataFile.save(params[:upload])
    render :text => "File has been uploaded successfully"
  end
end
