class AddIndexToUserfilemapping < ActiveRecord::Migration
  def change
    add_index :userfilemappings, :tablename, unique: true
    rename_column :userfilemappings, :filname, :filename    
  end
end
