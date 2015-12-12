class CreditPayment < ActiveRecord::Base
  belongs_to :credits
  belongs_to :credit_payment_type, :foreign_key => :payment_type_id
end
