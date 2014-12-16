class CreateDatauploaders < ActiveRecord::Migration
  def change
    create_table :datauploaders do |t|

      t.timestamps
    end
  end
end
