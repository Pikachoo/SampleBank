class ClientCredit < ActiveRecord::Base
  paginates_per 2
  belongs_to :client
  belongs_to :credit
  belongs_to :credit_payment_type, :foreign_key => :payment_id
  belongs_to :credit_granting_type, :foreign_key => :granting_id

  def update_state(state)
    if state == 1
      self.update_attributes(begin_date: Date.today)
      Account.create_account(self)
      User.create_user_for_client(self.client_id)
    end
    self.update_attributes(credit_state: state)
  end
end
