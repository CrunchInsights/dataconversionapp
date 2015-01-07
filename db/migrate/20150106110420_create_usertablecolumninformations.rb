class CreateUsertablecolumninformations < ActiveRecord::Migration
  def change
    create_table :usertablecolumninformations do |t|
      t.string :tablename
      t.string :columnname
      t.string :moneyformat
      t.boolean :isdisable
      t.integer :created_by
      t.datetime :created_on
      t.integer :modified_by
      t.datetime :modified_on

      t.timestamps
    end
  end
end
