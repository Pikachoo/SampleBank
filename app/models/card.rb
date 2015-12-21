class Card < ActiveRecord::Base
  belongs_to :client
  belongs_to :account

  paginates_per 5

  def self.create_card(account_id, client_id)
    rnd = Random.new
    card_number = rnd.rand(1000000000000000..9999999999999999) #44
    card_cvv = rnd.rand(100..999)
    card = self.create(account_id: account_id,
                       client_id: client_id,
                       number: card_number,
                       card_type: 'Visa Electron',
                       cvv: card_cvv,
                       date_expiry: Timemachine.get_current_date + 1.year)
    card
  end
end
