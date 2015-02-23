class AddNewColumnToUserFileMappings < ActiveRecord::Migration
  def change
    add_column :user_file_mappings, :total_records, :integer
    add_column :user_file_mappings, :success_records, :integer
    add_column :user_file_mappings, :error_records, :integer
  end
end
