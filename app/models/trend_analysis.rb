class TrendAnalysis < ActiveRecord::Base
  def self.get_enabled_column_data(data, table_name)
    # find only enable column's records
    my_sql="SELECT #{(data.collect{|obj| obj[:column_name]}).join(', ')} FROM #{table_name}"
    records = ActiveRecord::Base.connection.execute(my_sql)
    if records.to_a.size > 0 then
      records.values.each do |result|
        i=0
        result.each do |per_field_value|
          if per_field_value == nil then
            data[i][:record].append(per_field_value)
          else
            if data[i][:type].include?'int' then
              data[i][:record].append(per_field_value.strip.to_i)
            elsif data[i][:type] == "numeric" then
              data[i][:record].append(per_field_value.strip.to_f)
            elsif data[i][:type].include?'bool' then
              if per_field_value == 't' then
                per_field_value = "True"
              else
                per_field_value = "False"
              end
              data[i][:record].append(per_field_value.strip)
            else
              data[i][:record].append(per_field_value.strip)

            end
          end
          i = i + 1;
        end
      end
    end
    puts "***************"
    puts data
    data.each do |result_analysis|
      rec_hash = UserTableColumnInformation.where("table_name =? and column_name =?", table_name, result_analysis[:column_name]).first
      if rec_hash then
        result_analysis[:money_format]= rec_hash.money_format
      end
      #removing blank, null and nil values from array
      result_analysis[:record] = result_analysis[:record].reject { |c| c.blank? }
      if ((!(result_analysis[:type].include?'varchar')) && (!(result_analysis[:type].include?'bool'))) then
        result_analysis[:min] = result_analysis[:record].min
        result_analysis[:max] = result_analysis[:record].max
      end
      result_analysis[:count] = result_analysis[:record].size
      org_records = result_analysis[:record]
      unique_records = result_analysis[:record].uniq
      result_analysis[:record] = []
      unique_records.each do |unique_record|
        count_rec = org_records.count(unique_record)
        result_analysis[:record].append({:value => unique_record, :count => count_rec});
      end
    end
    return data
  end
end
