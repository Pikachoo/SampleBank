class Account < ActiveRecord::Base
  # attr_accessor :id, :account_type, :IBAN, :balance, :currency_id, :client_id, :is_sms,
  #               :is_email, :is_active, :is_deleted
  belongs_to :user
  belongs_to :currency
  has_many :cards
end
