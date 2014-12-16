class Userfilemapping < ActiveRecord::Base
  belongs_to :user
  validates :filename, presence: true
  validates :tablename, uniqueness: true, presence: true    
end
