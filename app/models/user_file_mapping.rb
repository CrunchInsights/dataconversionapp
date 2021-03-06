class UserFileMapping < ActiveRecord::Base
  belongs_to :user
  validates :file_name, presence: true
  validates :table_name, uniqueness: true, presence: true

  def self.insert_uploaded_file_record(current_user, file_name, table_name,file_upload_status)
    UserFileMapping.create(
        user: current_user,
        file_name: file_name,
        table_name: table_name,
        file_upload_status:file_upload_status,
        created_by: current_user.id,
        created_on: Time.now,
        modified_by: current_user.id,
        modified_on: Time.now)
  end

  def self.update_uploaded_file_status(table_name, file_upload_status)
    file_upload_record = UserFileMapping.find_by(:table_name=>table_name)
    file_upload_record.file_upload_status = file_upload_status
    file_upload_record.save
  end
end
