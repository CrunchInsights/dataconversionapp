class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  def get_usertablecolumninfo(tableName)
    tableColumnInfo = Usertablecolumninformation.where("tablename =? and isdisable =?", tableName, 1)
    disabledColumn=[]
    if tableColumnInfo.size > 0 then
      tableColumnInfo.each do |column|
        disabledColumn.append(column.columnname)
      end
    end
    return disabledColumn
  end

end
