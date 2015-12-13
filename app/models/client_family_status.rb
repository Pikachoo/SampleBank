class ClientFamilyStatus < ActiveRecord::Base
  self.table_name = 'client_family_status';

  has_many :clients
end
