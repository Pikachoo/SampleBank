class Currency < ActiveRecord::Base
  has_many :account
end
