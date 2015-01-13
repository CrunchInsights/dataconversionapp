class UserFileMapping < ActiveRecord::Base
  belongs_to :user
  validates :file_name, presence: true
  validates :table_name, uniqueness: true, presence: true

  def self.insert_uploaded_file_record(current_user, file_name, table_name)
    UserFileMapping.create(
        user: current_user,
        file_name: file_name,
        table_name: table_name,
        created_by: current_user.id,
        created_on: Time.now,
        modified_by: current_user.id,
        modified_on: Time.now)
  end
end
