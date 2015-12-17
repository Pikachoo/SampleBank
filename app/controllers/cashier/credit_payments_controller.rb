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
        payments = calculate_payments(client_credit)
        cur_date = Timemachine.find(1)
        puts cur_date
      else
        redirect_to :back, params: params, flash: {validation_errors: ['Такого кредита не существует'],
                                                   inputs_params: {credit_number: client_credit_id}}
      end
    end

    def calculate_payments(client_credit)

      payments = Array.new

      sum = client_credit.sum.to_f
      term = client_credit.term
      credit_percent = client_credit.credit.percent.to_f / 100
      coefficient = credit_percent / 12

      if client_credit.repayment_method == 'Равными долями'
        payment = (sum * coefficient)/(1 - 1 / ((1 + coefficient) ** term))
        all_sum = sum
        1.upto(12) do |time|
          percent_payment = all_sum * coefficient
          main_payment = payment - percent_payment
          payments.push({:main_payment => main_payment,
                         :percent_payment => percent_payment,
                         :payment => payment})
        end
      elsif client_credit.repayment_method == 'Стандартный'
        main_payment = sum / term
        1.upto(12) do |time|
          percent_payment = (sum - (time - 1) * sum / term) * coefficient
          payments.push({:main_payment => main_payment,
                         :percent_payment =>percent_payment,
                         :payment => (main_payment + percent_payment)})
        end
      end

      payments
    end
  end
end
