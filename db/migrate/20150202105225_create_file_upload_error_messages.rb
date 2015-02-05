class CreateFileUploadErrorMessages < ActiveRecord::Migration
  def change
    create_table :file_upload_error_messages do |t|
      t.string :table_name
      t.string :error_message

      t.timestamps
    end
  end
end
