class CreateUserfilemappings < ActiveRecord::Migration
  def change
    create_table :userfilemappings do |t|
      t.references :user, index: true
      t.string :filename, limit: 100
      t.string :tablename, limit: 100
      t.integer :created_by
      t.datetime :created_on
      t.integer :modified_by
      t.datetime :modified_on

      t.timestamps
    end
  end
end
