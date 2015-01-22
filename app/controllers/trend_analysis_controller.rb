class TrendAnalysisController < ApplicationController
  add_breadcrumb "Home", :root_path, :options => { :title => "Home" }
  def simple_trend
    @table_record=[]
    table_name = params[:table_name]
    param_hash = {:table_name => table_name}
    get_initial_breadcrumbs(param_hash)
    add_breadcrumb "Simple Trend", simpletrend_recordtrends_path, :title => "Simple Trend"
    #get table schema
    uploaded_schema = DataUploader.get_uploaded_schema(table_name)
    if uploaded_schema.size > 0 then
      disabled_column = get_user_table_column_info(table_name)
      uploaded_schema.each do |schema|
        if disabled_column.size > 0 then
          if !disabled_column.include?schema[:Field] then
            @table_record.append({column_name: schema[:Field], type: schema[:Type], is_unique: schema[:Key], min: 0, max: 0, count: 0, money_format: '', record:[]})
          end
        else
          @table_record.append({column_name: schema[:Field], type: schema[:Type], is_unique: schema[:Key], min: 0, max: 0, count: 0, money_format: '', record:[]})
        end
      end

      @table_record = TrendAnalysis.get_enabled_column_data(@table_record, table_name)
    end
  end

  private
    def get_initial_breadcrumbs(param_hash)
      initalize_breadcrumb("Uploaded File(s)", uploadedfile_datauploaders_path)
      initalize_breadcrumb("Uploaded File Schema", showuploadedschema_datauploaders_path({:table_name => param_hash[:table_name]}))
    end
end
