class Client < ActiveRecord::Base

  has_many :cards
  has_many :accounts
  has_many :client_credits
  belongs_to :client_family_status, :foreign_key => :family_status_id
  belongs_to :client_job_type, :foreign_key => :job_type_id

  def self.get_client_id_by_user_id(user_id)
    Client.find_by(:user_id => user_id)
  end
end
