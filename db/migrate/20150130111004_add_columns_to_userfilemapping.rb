class AddColumnsToUserfilemapping < ActiveRecord::Migration
  def change
    add_column :user_file_mappings, :has_error_record, :boolean, default: false
    add_column :user_table_column_informations, :is_percentage_value, :boolean, default: false
  end
end
