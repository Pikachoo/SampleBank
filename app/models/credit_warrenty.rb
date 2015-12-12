class CreditWarrenty < ActiveRecord::Base
  belongs_to :credit
  belongs_to :credit_warrenty_type,  :foreign_key => :warrenty_type_id
end
