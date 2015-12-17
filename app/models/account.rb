require 'net/http'
require 'uri'
class Account < ActiveRecord::Base

  belongs_to :user
  belongs_to :currency
  has_many :cards

  def self.create_account(client_credit)
    uri = URI.parse("http://bank.tarnenok.by/api/accounts/open?typeId=1&currencyId=#{client_credit.credit.currency_id}&clientId=#{client_credit.client.id}&sum=#{client_credit.sum}")
    req = Net::HTTP::Post.new(uri.request_uri)
    res = Net::HTTP.start(uri.hostname, uri.port) { |http|
      http.request(req)
    }

    account_hash = JSON.parse(res.body)
    account = Account.find(account_hash['id'])
    account
  end
end
