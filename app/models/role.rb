class Role < ActiveRecord::Base
  self.table_name = 'user_roles'
  has_many :users
end
