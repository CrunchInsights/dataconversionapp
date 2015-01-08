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
    begin
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
    rescue
      return uploadedSchema
    end
  end

  def self.insertCsvData(filePath, tableName, columnStructureObject)
    if columnStructureObject.size > 0 then
      tableColumns = []
      #puts "11111111111111111111"
      #puts columnStructureObject
      columnStructureObject.each do |columnName|       
        tableColumns.append(columnName[:columnName])
      end
      tableColStr = tableColumns.map{|col| "#{col}"}.join(", ")
      #puts "22222222222222222222222222222"
      #puts tableColStr
      options = {
         :row_sep => :auto,
         :chunk_size => 2,
         :remove_empty_values => false,
         :remove_zero_values => false,
         :remove_values_matching => nil
      }
      SmarterCSV.process(filePath, options) do |chunk|
        chunk.each do |data_hash|
          data_hash = data_hash.to_a
          data_hash = data_hash.transpose
          data_hash.shift
          insertedRowString = ''
          i = 0
          data_hash[0].each do |insertedRowValue|
            if insertedRowValue == nil then
              insertedRowString = insertedRowString + "NULL, "
            elsif ((insertedRowValue.to_s.strip.downcase == "null") || (insertedRowValue.to_s.strip.downcase) == "nil" || (insertedRowValue.to_s.strip == "")) then
              insertedRowString = insertedRowString + "NULL, "
            else
              if columnStructureObject[i][:dataType] == "datetime" then
                if columnStructureObject[i][:dateformat] != "" then
                  insertedRowString = insertedRowString + "'" + DateTime.strptime(insertedRowValue.strip, columnStructureObject[i][:dateformat]).strftime("%Y-%m-%d %H:%M:%S").to_s + "', "
                else
                  insertedRowString = insertedRowString + "'" + DateTime.parse(insertedRowValue.strip).strftime("%Y-%m-%d %H:%M:%S").to_s + "', "
                end
              elsif columnStructureObject[i][:dataType] == "integer" then
                insertedRowString = insertedRowString + insertedRowValue.to_s.to_s + ", "
              elsif columnStructureObject[i][:dataType] == "decimal" then
                insertedRowString = insertedRowString + "'" + insertedRowValue.to_s.to_s + "', "
              elsif columnStructureObject[i][:dataType] == "string" then
                insertedRowString = insertedRowString + "'" + insertedRowValue.strip.to_s + "', "
              elsif columnStructureObject[i][:dataType] == "boolean" then
                 if insertedRowValue == 'on' then
                   insertedRowString = insertedRowString + 1.to_s + ", "
                 elsif insertedRowValue == 'off' then
                   insertedRowString = insertedRowString + 0.to_s + ", "
                 elsif insertedRowValue == 'true' then
                   insertedRowString = insertedRowString + 1.to_s + ", "
                 elsif insertedRowValue == 'false' then
                   insertedRowString = insertedRowString + 0.to_s + ", "
                 elsif insertedRowValue == 'yes' then
                   insertedRowString = insertedRowString + 1.to_s + ", "
                 elsif insertedRowValue == 'no' then
                   insertedRowString = insertedRowString + 0.to_s + ", "
                 elsif insertedRowValue == '1' then
                   insertedRowString = insertedRowString + 1.to_s + ", "
                 elsif insertedRowValue == '0' then
                   insertedRowString = insertedRowString + 0.to_s + ", "
                 else
                   insertedRowString = insertedRowString + insertedRowValue.to_s.strip + ", "
                 end
              end
            end
            i = i+1;
          end
          insertedRowString = insertedRowString[0...-2]
          my_sql="INSERT INTO #{tableName} (#{tableColStr}) Values (#{insertedRowString})"
          resultSet = ActiveRecord::Base.connection.execute(my_sql)
        end
      end
    end
  end
end
