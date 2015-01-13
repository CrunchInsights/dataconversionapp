class CreateUserTableColumnInformations < ActiveRecord::Migration
  def change
    create_table :user_table_column_informations do |t|
      t.string :table_name
      t.string :column_name
      t.string :money_format
      t.boolean :is_disable
      t.integer :created_by
      t.datetime :created_on
      t.integer :modified_by
      t.datetime :modified_on

      t.timestamps
    end
  end
end
