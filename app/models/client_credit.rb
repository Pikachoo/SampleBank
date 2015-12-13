class ClientCredit < ActiveRecord::Base
  paginates_per 2
  belongs_to :client
  belongs_to :credit
  belongs_to :credit_payment_type, :foreign_key => :payment_id
  belongs_to :credit_granting_type, :foreign_key => :granting_id
end
