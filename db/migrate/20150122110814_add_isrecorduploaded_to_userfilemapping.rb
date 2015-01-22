class AddIsrecorduploadedToUserfilemapping < ActiveRecord::Migration
  def change
    add_column :user_file_mappings, :is_record_uploaded, :boolean, default: false
    add_column :user_file_mappings, :is_table_created, :boolean, default: false
  end
end
