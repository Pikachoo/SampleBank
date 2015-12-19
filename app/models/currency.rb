class Currency < ActiveRecord::Base
  has_many :account
  has_many :credits
  def self.exchange_sum(currency_from, currency_to, sum)
    currency_from_id = Currency.find_by_name(currency_from)
    currency_to_id = Currency.find_by_name(currency_to)
    if currency_from_id == currency_to_id
      final_sum = sum.to_f
    else
      exchange_rate = ExchangeRate.find_by(from_currency_id: currency_from_id, to_currency_id: currency_to_id)
      if exchange_rate
        final_sum = sum.to_f * exchange_rate.coefficient
      else
        exchange_rate = ExchangeRate.find_by(from_currency_id: currency_to_id, to_currency_id: currency_from_id)
        final_sum = sum.to_f / exchange_rate.coefficient
      end
    end

    final_sum
  end
end
