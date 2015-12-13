class CreditPaymentType < ActiveRecord::Base
  has_many :credit_payments
  has_many :client_credits
end
