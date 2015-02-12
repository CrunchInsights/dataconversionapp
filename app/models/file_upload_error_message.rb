class FileUploadErrorMessage < ActiveRecord::Base  
	def self.table_upload_error_record(table_name)
		table_error_record = FileUploadErrorMessage.where("table_name =?", table_name)
	    table_error_record = table_error_record.to_a
	    result = []
	    if table_error_record.size > 0 then
	      table_error_record.each do |error_record|
	        result.append(error_record)
	      end
	    end
	    return result
	end
end
