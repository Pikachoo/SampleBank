class Currency < ActiveRecord::Base
  has_many :account
  has_many :credits
end
