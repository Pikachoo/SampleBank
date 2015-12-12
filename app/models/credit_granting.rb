class CreditGranting < ActiveRecord::Base
  belongs_to :credit
  belongs_to :credit_granting_type,  :foreign_key => :granting_type_id
end
