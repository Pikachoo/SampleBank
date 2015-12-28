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
        @paymens_params = ClientCredit.credit_payments(client_credit)
      else
        redirect_to :back, params: params, flash: {validation_errors: ['Такого кредита не существует'],
                                                   inputs_params: {credit_number: @client_credit_id}}
      end
    end


    def pay
      @client_credit_id = params[:credit_id]
      payment_id = params[:payment_id]
      sum = params[:sum]
      penalty = params[:penalty_sum]

      if Order.find_by(credit_id: @client_credit_id, payment_number: payment_id)
        @message = 'Платеж уже был проведен.'
      else
        Order.create(credit_id: @client_credit_id, payment_number: payment_id, sum: sum, penalty_sum: penalty, order_date: Date.today)
      end
      @paymens_params = ClientCredit.credit_payments(ClientCredit.find(@client_credit_id))

      User.send_email(self.client.email, "Кредит №#{@client_credit_id}:\nПлатеж №#{payment_id} оплачен.\nСумма: #{sum} .\n")
      User.send_sms(self.client.phone_mobile[1..-1], "Кредит №#{@client_credit_id}:\nПлатеж №#{payment_id} оплачен.\nСумма: #{sum} .\n")
      render 'create'
    end


  end
end
