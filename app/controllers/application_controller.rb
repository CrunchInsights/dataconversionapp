class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  def get_user_table_column_info(table_name)
    table_column_info = UserTableColumnInformation.where("table_name =? and is_disable =?", table_name, true)
    table_column_info=table_column_info.to_a
    disabled_column = []
    if table_column_info.size > 0 then
      table_column_info.each do |column|
        disabled_column.append(column.column_name)
      end
    end
    return disabled_column
  end

  def add_breadcrumb_for_simple_trend()
    add_breadcrumb "Uploaded File(s)", uploadedfile_datauploaders_path, :title => "Uploaded File(s)"
    add_breadcrumb "Uploaded File Schema", showuploadedschema_datauploaders_path, :title => "Uploaded File Schema"
  end
end
