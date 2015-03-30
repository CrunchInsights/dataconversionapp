class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  def get_user_table_column_info(table_name)
    table_column_info = UserTableColumnInformation.where("table_name =?", table_name)
    table_column_info=table_column_info.to_a
    column_detail_array = []
    if table_column_info.size > 0 then
      table_column_info.each do |column|
        column_detail_hash = {:column_name=> '', :money_format=> '', :is_disable => false, :percentage_format => false}
        column_detail_hash[:column_name] = column.column_name  
        column_detail_hash[:money_format] = column.money_format 
        column_detail_hash[:is_disable] = column.is_disable 
        column_detail_hash[:percentage_format] =  column.is_percentage_value 
        column_detail_array.append(column_detail_hash)
      end
    end
    return column_detail_array
  end

  def initalize_breadcrumb(breadcrumb_name, breadcrumb_path)
    add_breadcrumb breadcrumb_name, breadcrumb_path, :title => breadcrumb_name
  end
end
