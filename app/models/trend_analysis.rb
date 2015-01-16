class TrendAnalysis < ActiveRecord::Base
  def self.get_enabled_column_data(data, table_name)
    # find only enable column's records
    my_sql="SELECT #{(data.collect{|obj| obj[:column_name]}).join(', ')} FROM #{table_name}"
    records = ActiveRecord::Base.connection.execute(my_sql)
    if records.to_a.size > 0 then
      records.values.each do |result|
        i=0
        result.each do |per_field_value|
          data[i][:record].append(per_field_value)
          i = i + 1;
        end
      end
    end
    i=0
    data.each do |result_analysis|
      rec_hash = UserTableColumnInformation.where("table_name =? and column_name =?", table_name, result_analysis[:column_name]).first
      if rec_hash then
        result_analysis[:money_format]= rec_hash.money_format
      end
      #removing blank, null and nil values from array
      result_analysis[:record] = result_analysis[:record].reject { |c| c.blank? }
      if ((!(result_analysis[:type].include?'varchar')) && (!(result_analysis[:type].include?'boolean'))) then
        result_analysis[:min] = result_analysis[:record].min
        result_analysis[:max] = result_analysis[:record].max
      end
      result_analysis[:count] = result_analysis[:record].size
      if i == 0
        result_analysis[:record] =[{:value=>"pramod", :count=>56},{:value=>"dharmu", :count=>24},{:value=>"lokesh", :count=>34}]
      else
        result_analysis[:record] =[{:value=>"nitin", :count=>20},{:value=>"digvijay", :count=>30},{:value=>"amirsh", :count=>40}]
      end
      i=i+1
    end
    return data
  end
end
