class CreditPaymentType < ActiveRecord::Base
  has_many :credit_payments
end
