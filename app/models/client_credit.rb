class ClientCredit < ActiveRecord::Base
  paginates_per 25
  belongs_to :client
  belongs_to :credit
  belongs_to :credit_payment_type, :foreign_key => :payment_id
  belongs_to :credit_granting_type, :foreign_key => :granting_id


  def update_state(state)
    if state == 1
      account = Account.create_account(self)
      self.update_attributes(account_id: account.id, begin_date: Date.today)
      User.create_user_for_client(self.client_id)
    end
    self.update_attributes(credit_state: state)
  end
end
