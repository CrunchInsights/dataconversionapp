class CreateTableErrorRecords < ActiveRecord::Migration
  def change
    create_table :table_error_records do |t|
      t.string :table_name
      t.integer :row_id
      t.string :error_message
      t.text :error_record
      t.timestamps
    end
  end
end
