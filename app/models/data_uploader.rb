class DataUploader < ActiveRecord::Base
  def self.create_dynamic_table(table_name, column_structure_object)
    begin
      unique_columns = []
      if column_structure_object.size > 0
        ActiveRecord::Schema.define do
          create_table "#{table_name}", :id => false do |t|
            column_structure_object.each do |column_struct|
              case column_struct[:data_type]
                when 'boolean'
                  t.column column_struct[:column_name], column_struct[:data_type], null: column_struct[:is_nullable]
                when 'decimal'
                  t.column column_struct[:column_name], column_struct[:data_type], null: column_struct[:is_nullable], precision: (column_struct[:field_length].split(',')[0]).to_i, scale: (column_struct[:field_length].split(',')[1]).to_i
                when 'datetime'
                  t.column column_struct[:column_name], column_struct[:data_type], null: column_struct[:is_nullable]
                when 'integer'
                  if column_struct[:is_unique] == true then
                    unique_columns.append(column_struct[:column_name])
                  end
                  t.column column_struct[:column_name], column_struct[:data_type], null: column_struct[:is_nullable]
                else
                  if column_struct[:is_unique] == true then
                    unique_columns.append(column_struct[:column_name])
                  end
                  t.column column_struct[:column_name], column_struct[:data_type], null: column_struct[:is_nullable], limit: column_struct[:field_length]
              end
            end
          end
          unique_columns.each do |uniqCol|
            add_index table_name, uniqCol, unique: true
          end
        end
      end
      return true
    rescue Exception => err
      return err.message
    end
  end

  def self.get_uploaded_schema(table_name)
    uploaded_schema = []
    begin
      my_sql= "Select temp.column_name as field, temp.data_type as field_data_type_long, temp.character_maximum_length as field_length,
      temp.is_nullable as nullable, temp.udt_name as type,
      CASE
      WHEN temp2.indisprimary = 't' THEN 'PRIMARY'
      WHEN temp2.indisunique = 't' THEN 'UNIQUE'
      ELSE ''
      END AS key
      from (select isc.column_name, isc.data_type, isc.character_maximum_length, isc.is_nullable, isc.udt_name
      from INFORMATION_SCHEMA.COLUMNS isc WHERE isc.table_name = '#{table_name}') as temp
      LEFT JOIN (SELECT pga.attname, pgi.indisunique, pgi.indisprimary
      FROM pg_index pgi
      LEFT JOIN pg_class pgc
      ON pgi.indrelid  = pgc.oid
      LEFT JOIN pg_attribute pga
      ON pga.attrelid = pgc.oid
      AND pga.attnum = ANY(indkey)
      WHERE pgc.relname =  '#{table_name}' ) as temp2
      ON temp.column_name = temp2.attname;"
      #my_sql = "DESC"

      result_set = ActiveRecord::Base.connection.execute(my_sql)

      result_set=result_set.to_a
      if result_set.size > 0
        result_set.each do |result|
          result_schema = {}
          result_schema[:Field] = result["field"]
          result_schema[:Type] = result["type"]
          result_schema[:Null] = result["nullable"]
          result_schema[:Key] = result["key"]
          uploaded_schema.append(result_schema)

        end
      end
      return uploaded_schema
    rescue
      return uploaded_schema
    end
  end

  def self.insert_csv_data(file_path, table_name, column_structure_object)
    if column_structure_object.size > 0
      table_columns = []
      column_structure_object.each do |column_name|
        table_columns.append(column_name[:column_name])
      end
      table_col_str = table_columns.map{|col| "#{col}"}.join(', ')
      options = {
          :row_sep => :auto,
          :chunk_size => 50,
          :remove_empty_values => false,
          :remove_zero_values => false,
          :remove_values_matching => nil
      }
      SmarterCSV.process(file_path, options) do |chunk|
        chunk_insert_string = ''
        chunk.each do |data_hash|
          data_hash = data_hash.to_a
          data_hash = data_hash.transpose
          data_hash.shift
          inserted_row_string = ''
          i = 0
          data_hash[0].each do |inserted_row_value|
            if inserted_row_value == nil then
              inserted_row_string = inserted_row_string + 'NULL, '
            elsif ((inserted_row_value.to_s.strip.downcase == 'null') || (inserted_row_value.to_s.strip.downcase) == "nil" || (inserted_row_value.to_s.strip == "")) then
              inserted_row_string = inserted_row_string + 'NULL, '
            else
              if column_structure_object[i][:data_type] == "datetime" then
                if column_structure_object[i][:date_format] != "" then
                  inserted_row_string = inserted_row_string + "'" + DateTime.strptime(inserted_row_value.strip, column_structure_object[i][:date_format]).strftime("%Y-%m-%d %H:%M:%S").to_s + "', "
                else
                  inserted_row_string = inserted_row_string + "'" + DateTime.parse(inserted_row_value.strip).strftime("%Y-%m-%d %H:%M:%S").to_s + "', "
                end
              elsif column_structure_object[i][:data_type] == "integer" then
                inserted_row_string = inserted_row_string + inserted_row_value.to_s.to_s + ", "
              elsif column_structure_object[i][:data_type] == "decimal" then
                if column_structure_object[i][:is_money_format] == true
                  inserted_row_value = inserted_row_value.to_s.tr(column_structure_object[i][:money_symbol],'').strip
                  inserted_row_string = inserted_row_string + "'" + inserted_row_value.gsub(/,/,'').to_s + "', "
                else
                  inserted_row_string = inserted_row_string + "'" + inserted_row_value.to_s + "', "
                end
              elsif column_structure_object[i][:data_type] == "string" then
                inserted_row_string = inserted_row_string + "'" + inserted_row_value.strip.to_s + "', "
              elsif column_structure_object[i][:data_type] == "boolean" then
                if inserted_row_value == 'on' then
                  inserted_row_string = inserted_row_string + true.to_s + ", "
                elsif inserted_row_value == 'off' then
                  inserted_row_string = inserted_row_string + false.to_s + ", "
                elsif inserted_row_value == 1 then
                  inserted_row_string = inserted_row_string + true.to_s + ", "
                elsif inserted_row_value == 0 then
                  inserted_row_string = inserted_row_string + false.to_s + ", "
                elsif inserted_row_value == 'yes' then
                  inserted_row_string = inserted_row_string + true.to_s + ", "
                elsif inserted_row_value == 'no' then
                  inserted_row_string = inserted_row_string + false.to_s + ", "
                elsif inserted_row_value == '1' then
                  inserted_row_string = inserted_row_string + true.to_s + ", "
                elsif inserted_row_value == '0' then
                  inserted_row_string = inserted_row_string + false.to_s + ", "
                else
                  inserted_row_string = inserted_row_string + inserted_row_value.to_s.strip + ", "
                end
              end
            end
            i = i+1
          end
          inserted_row_string = inserted_row_string[0...-2]
          chunk_insert_string = chunk_insert_string + "(#{inserted_row_string}), "
        end
        chunk_insert_string = chunk_insert_string[0...-2]
        my_sql="INSERT INTO #{table_name} (#{table_col_str}) Values #{chunk_insert_string}"
        result_set = ActiveRecord::Base.connection.execute(my_sql)
      end
      user_table_mapping = UserFileMapping.where("table_name =?", table_name).first
      if user_table_mapping then
        user_table_mapping.is_record_uploaded = true
        user_table_mapping.save
      end
    end
  end

  def self.get_table_data(table_name)
    result = []
    begin
      my_sql="SELECT * FROM #{table_name}"
      result = ActiveRecord::Base.connection.execute(my_sql)
      return result
    rescue Exception => err
      return result
    end
  end

  def self.check_table_exist(table_name)
    result = []
    begin
      my_sql = "SELECT EXISTS(SELECT * FROM information_schema.tables WHERE table_name = '#{table_name}') as is_exist"
      result = ActiveRecord::Base.connection.execute(my_sql)
      return result
    rescue Exception => err
      return result
    end
  end

  def self.drop_table_if_exist(table_name)
    result = []
    begin
      my_sql = "DROP table #{table_name}"
      result = ActiveRecord::Base.connection.execute(my_sql)
      return result
    rescue Exception => err
      return result
    end
  end
end
