require 'net/http'
require 'uri'
class Account < ActiveRecord::Base
  paginates_per 5

  belongs_to :user
  belongs_to :currency
  has_many :cards

  def self.create_account(client_credit)
    if client_credit.account_id == 0
      uri = URI.parse("http://bank.tarnenok.by/api/accounts/open?typeId=1&currencyId=#{client_credit.credit.currency_id}&clientId=#{client_credit.client.id}&balance=#{client_credit.sum}")
      req = Net::HTTP::Post.new(uri.request_uri)
      res = Net::HTTP.start(uri.hostname, uri.port) { |http|
        http.request(req)
      }

      account_hash = JSON.parse(res.body)
      account = Account.find(account_hash['id'])
      account
    else
      nil
    end
  end
end
