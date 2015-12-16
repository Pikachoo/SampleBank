module Cashier
  class CreditPaymentsController < ApplicationController
    def new
      @cashbox_inputs = {credit_number: ''}
      @cashbox_inputs = flash[:inputs_params] if flash[:inputs_params] != nil
    end

    def create
      client_credit_id = params[:credit_payments][:credit_number]

      client_credit = ClientCredit.where(id: client_credit_id)
      if !client_credit.empty?
        final_sum = exchange_sum(currency_id, client_credit.credit.currency_id, sum)
        client_credit.update_attributes(brought_sum: final_sum)
      else
        redirect_to :back, params: params, flash: {validation_errors: ['Такого кредита не существует'],
                                                   inputs_params: {credit_number: client_credit_id}}
      end
    end
  end
end
