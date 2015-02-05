class AddColumnToUserfilemappigs02022015 < ActiveRecord::Migration
  def change
    add_column :user_file_mappings, :file_upload_status, :string
  end
end
