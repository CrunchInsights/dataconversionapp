class Usertablecolumninformation < ActiveRecord::Base
  validates :columnname, presence: true
  validates :tablename,  presence: true
end
