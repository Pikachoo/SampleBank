class Client < ActiveRecord::Base

  has_many :cards
  has_many :accounts

  def self.get_client_id_by_user_id(user_id)
    Client.find_by(:user_id => user_id)
  end
end
