module Cashier
  class CreditPaymentsController < ApplicationController
    def new
      @cashbox_inputs = {credit_number: ''}
      @cashbox_inputs = flash[:inputs_params] if flash[:inputs_params] != nil
    end

    def create
      client_credit_id = params[:credit_payments][:credit_number]

      client_credit = ClientCredit.find_by(id: client_credit_id)
      if !client_credit.nil?
        calculate_payments(client_credit)
      else
        redirect_to :back, params: params, flash: {validation_errors: ['Такого кредита не существует'],
                                                   inputs_params: {credit_number: client_credit_id}}
      end
    end

    def calculate_payments(client_credit)

      if client_credit.repayment_method == 'Равными долями'
        credit_percent = client_credit.credit.percent.to_f/100
        coefficient = credit_percent / 12
        payment = (client_credit.sum * coefficient)/(1 - 1 / ((1 + coefficient) ** client_credit.term))
        puts payment
      elsif client_credit.repayment_method == 'Стандартный'
        payments = Array.new
        credit_percent = client_credit.credit.percent.to_f/100
        coefficient = credit_percent / 12
        sum = client_credit.sum.to_f
        term = client_credit.term.to_f
        main_payment = sum / term

        puts main_payment
        1.upto(12) do |time|
          payment = (sum - (time - 1) * sum / term) * coefficient
          payments.push(payment)
        end
      end
    end
  end
end
