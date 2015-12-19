module Cashier
  class CreditPaymentsController < ApplicationController
    before_filter :check_is_manage

    def check_is_manage
      raise unless User.find(session[:user_id]).is?('cashier')
    end

    def new
      @cashbox_inputs = {credit_number: ''}
      @cashbox_inputs = flash[:inputs_params] if flash[:inputs_params] != nil
    end

    def create
      @client_credit_id = params[:credit_payments][:credit_number]
      client_credit = ClientCredit.find_by(id: @client_credit_id)
      if !client_credit.nil?
        credit_payments(client_credit)
      else
        redirect_to :back, params: params, flash: {validation_errors: ['Такого кредита не существует'],
                                                   inputs_params: {credit_number: @client_credit_id}}
      end
    end


    def pay
      @client_credit_id = params[:credit_id]
      payment_id = params[:payment_id]
      sum = params[:sum]

      Order.create(credit_id: @client_credit_id, payment_number: payment_id, sum: sum, order_date: Date.today)
      credit_payments(ClientCredit.find(@client_credit_id))

      render 'create'
    end

    private
    def credit_payments(client_credit)
      orders = Order.where(credit_id: client_credit.id)
      payments = calculate_payments(client_credit)

      timemachine = Timemachine.find(1)
      timemachine_months = timemachine.cur_date.year * 12 + timemachine.cur_date.month
      credit_months = client_credit.begin_date.year * 12 + client_credit.begin_date.month
      days = timemachine.cur_date.day - client_credit.begin_date.day
      months = timemachine_months - credit_months

      if days < 0
        calculate_payments_params(months, payments, client_credit, orders)
      else
        calculate_payments_params(months + 1, payments, client_credit, orders)
      end
    end

    def calculate_payments_params(times, payments, client_credit, orders)
      @paymens_params = Array.new
      1.upto(times) do |time|
        is_payed = order_is_payed?(orders, time)
        penalty_payment = 0
        unless is_payed
          penalty_payment = calculate_penalty_payment(times - time, payments[time][:payment], client_credit.credit.default_interest.to_f / 100)
        end
        payments[time][:payment] += penalty_payment
        bel_payment = Currency.exchange_sum(client_credit.credit.currency.name, 'BYR', payments[time][:payment])
        @paymens_params.push({number: time,
                              main_payment: payments[time][:main_payment].round(2),
                              percent_payment: payments[time][:percent_payment].round(2),
                              payment: payments[time][:payment].round(2),
                              bel_payment: bel_payment.ceil.to_f.round(-2),
                              penalty_payment: penalty_payment.round(2),
                              expire_date: client_credit.begin_date.to_time.advance(:months => time).to_date,
                              is_payed: is_payed})
      end
    end

    def calculate_penalty_payment(months_numbers, payment, penalty_percent)
      penalty_payment = 0.0
      months_numbers.times do
        penalty_payment = penalty_payment + payment * penalty_percent
      end
      penalty_payment
    end

    def order_is_payed?(orders, order_number)
      orders.find_by(:payment_number => order_number)
      if orders.find_by(:payment_number => order_number)
        true
      else
        false
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
          all_sum -= main_payment
        end
      elsif client_credit.repayment_method == 'Стандартный'
        main_payment = sum / term
        1.upto(12) do |time|
          percent_payment = (sum - (time - 1) * sum / term) * coefficient
          payments.push({:main_payment => main_payment,
                         :percent_payment => percent_payment,
                         :payment => (main_payment + percent_payment)})
        end
      end

      payments
    end
  end
end
