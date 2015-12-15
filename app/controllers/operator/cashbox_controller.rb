module Operator
  class CashboxController < ApplicationController
    def new
      @cashbox_inputs = {sum: '', credit_number: ''}
      @cashbox_inputs = flash[:inputs_params] if flash[:inputs_params] != nil
    end

    def create
      sum = params[:cashbox][:sum]
      currency_id = params[:cashbox][:currency]
      client_credit_id = params[:cashbox][:credit_number]

      client_credit = ClientCredit.where(id: client_credit_id)
      unless client_credit.empty?
        final_sum = exchange_sum(currency_id, client_credit.credit.currency_id, sum)
        client_credit.update_attributes(brought_sum: final_sum)
      else
        redirect_to :back, params: params, flash: {validation_errors: ['Такого кредита не существует'],
                                                   inputs_params: {sum: sum, credit_number: client_credit_id, currency: currency_id}}
      end

    end

    def exchange_sum(currency_from_id, currency_to_id, sum)
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
end
