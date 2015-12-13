class CreditGrantingType < ActiveRecord::Base
  has_many :credit_grantings
end
