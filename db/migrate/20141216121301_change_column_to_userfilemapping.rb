class ChangeColumnToUserfilemapping < ActiveRecord::Migration
  def change
    change_column :userfilemappings, :tablename, :string, :null => false
    change_column :userfilemappings, :filename, :string, :null => false
  end
end
