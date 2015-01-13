class CreateUserFileMappings < ActiveRecord::Migration
  def change
    create_table :user_file_mappings do |t|
      t.references :user, index: true
      t.string :file_name, limit: 100, :null => false
      t.string :table_name, limit: 100, :null => false
      t.integer :created_by
      t.datetime :created_on
      t.integer :modified_by
      t.datetime :modified_on
    end
    add_index :user_file_mappings, :table_name, unique: true
  end
end
