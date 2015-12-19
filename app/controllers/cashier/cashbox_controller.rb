module Cashier
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
      if !client_credit.empty?
        final_sum = Currency.exchange_sum(Currency.find(currency_id).name, client_credit.credit.currency.name, sum)
        client_credit.update_attributes(brought_sum: final_sum)
      else
        redirect_to :back, params: params, flash: {validation_errors: ['Такого кредита не существует'],
                                                   inputs_params: {sum: sum, credit_number: client_credit_id, currency: currency_id}}
      end

    end




  end
end
