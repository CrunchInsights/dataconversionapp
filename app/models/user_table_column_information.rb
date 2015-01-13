class UserTableColumnInformation < ActiveRecord::Base
  validates :column_name, presence: true
  validates :table_name,  presence: true

  def self.update_column_information(current_user, is_column_disabled, table_name, column_name)
    begin
      update_column_info = UserTableColumnInformation.where("table_name =? AND column_name = ?", table_name, column_name).first
      if update_column_info then
        update_column_info.is_disable = is_column_disabled
        update_column_info.save
      else
        update_column_info = UserTableColumnInformation.create(
                                table_name: table_name,
                                column_name: column_name,
                                money_format:  '',
                                is_disable: is_column_disabled,
                                created_by: current_user.id,
                                created_on: Time.now ,
                                modified_by: current_user.id,
                                modified_on: Time.now)
      end
      return update_column_info
    rescue Exception => err
      return err.message
    end
  end
end
