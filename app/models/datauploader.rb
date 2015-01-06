require 'smarter_csv'
class Datauploader < ActiveRecord::Base
  def self.create_dynamic_table(table_name, columnStructureObject)
    begin
      uniqueColumns = []
      if columnStructureObject.size > 0 then
        ActiveRecord::Schema.define do
          create_table "#{table_name}", :id => false do | t |
            columnStructureObject.each do |columnStruct|
              case columnStruct[:dataType]
                when "boolean"
                  t.column columnStruct[:columnName], columnStruct[:dataType], null: columnStruct[:isNullable]
                when "decimal"
                  t.column columnStruct[:columnName], columnStruct[:dataType], null: columnStruct[:isNullable], precision: (columnStruct[:fieldLength].split(',')[0]).to_i, scale: (columnStruct[:fieldLength].split(',')[1]).to_i
                when "datetime"
                  t.column columnStruct[:columnName], columnStruct[:dataType], null: columnStruct[:isNullable]
                when "integer"
                  if columnStruct[:isUnique] == true then
                    uniqueColumns.append(columnStruct[:columnName])
                  end
                  t.column columnStruct[:columnName], columnStruct[:dataType], null: columnStruct[:isNullable]
                else
                  if columnStruct[:isUnique] == true then
                    uniqueColumns.append(columnStruct[:columnName])
                  end
                  t.column columnStruct[:columnName], columnStruct[:dataType], null: columnStruct[:isNullable], limit: columnStruct[:fieldLength]
              end
            end
          end
          uniqueColumns.each do |uniqCol|
            add_index table_name, uniqCol, unique: true
          end
        end
      end
      return true
    rescue Exception => err
      return err.message
    end
  end

  def self.getUploadedSchema(tableName)
    uploadedSchema = []
    my_sql = "DESC #{tableName}"
    resultSet = ActiveRecord::Base.connection.execute(my_sql)
    if resultSet.size > 0 then
      resultSet.each do |result|
        resultSchema = {}
        resultSchema[:Field] = result[0]
        resultSchema[:Type] = result[1]
        resultSchema[:Null] = result[2]
        resultSchema[:Key] = result[3]
        uploadedSchema.append(resultSchema)
      end
    end
    return uploadedSchema
  end

  def self.insertCsvData(filePath, tableName, columnStructureObject)
    if columnStructureObject.size > 0 then
      tableColumns = []      
      columnStructureObject.each do |columnName|       
        tableColumns.append(columnName[:columnName])
      end
      tableColStr = tableColumns.map{|col| "#{col}"}.join(", ")
      puts tableColStr
      options = {
          :row_sep => :auto,
          :chunk_size=>2,
          :remove_empty_values => false, :remove_zero_values => false, :remove_values_matching => nil
      }
      SmarterCSV.process(filePath, options) do |chunk|
        chunk.each do |data_hash|
          puts data_hash
          data_hash = data_hash.to_a
          puts "******************* after array ************************"
          puts data_hash
          data_hash = data_hash.transpose
          puts "******************* after transpose ************************"
          puts data_hash
          data_hash.shift
          puts "******************* after shift ************************"
          puts data_hash
          data_hash = data_hash[0].map{|c| "'#{c}'"}.join(", ")
          puts "******************* after join ************************"
          puts data_hash
          my_sql="INSERT INTO #{tableName} (#{tableColStr}) Values (#{data_hash})"
          resultSet = ActiveRecord::Base.connection.execute(my_sql)
        end
      end
    end
  end

end
