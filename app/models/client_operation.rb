class ClientOperation < ActiveRecord::Base
  belongs_to :account
  belongs_to :currency
end
