module Operator
  class CreditsController < ApplicationController
    load_and_authorize_resource
    skip_load_resource :only => :create
    def index
      @credits = Credit.all
    end
    def new

    end
    def create

      credit = Credit.new(credit_params)
      credit.currency_id = params[:credit][:currency]
      credit.save

      credit_warrenty_ids = params[:credit][:warrenty_type]
      credit_warrenty_ids = credit_warrenty_ids.split(",").map { |s| s.to_i }
      credit_warrenty_ids.each do |warrenty|
        credit_warrenty = CreditWarrenty.new(credit_id: credit.id, warrenty_type_id: warrenty)
        credit_warrenty_ids.save
      end


      credit_granting_ids = params[:credit][:granting_type]
      credit_granting_ids = credit_granting_ids.split(",").map { |s| s.to_i }
      credit_granting_ids.each do |granting|
        credit_granting = CreditGranting.new(credit_id: credit.id, granting_type_id: granting)
        credit_granting.save
      end

      credit_payment_ids = params[:credit][:payment_type]
      credit_payment_ids = credit_payment_ids.split(",").map { |s| s.to_i }
      credit_payment_ids.each do |payment|
        credit_payment = CreditPayment.new(credit_id: credit.id, payment_type_id: payment)
        credit_payment.save
      end

      @credits = Credit.all
      render 'operator/credits/index'
    end

    def edit

    end

    def destroy
      credit = Credit.find(params[:id])

      credit_grantings = CreditGranting.where(credit_id: credit.id)
      credit_grantings.each do |granting|
        granting.destroy
      end

      credit_payments = CreditPayment.where(credit_id: credit.id)
      credit_payments.each do |payment|
        payment.destroy
      end

      credit_warrenties = CreditWarrenty.where(credit_id: credit.id)
      credit_warrenties.each do |warrenty|
        warrenty.destroy
      end


      credit.destroy
      @credits = Credit.all
      render 'operator/credits/index'
    end
    private
    def credit_params
      params.require(:credit).permit(:name, :min_sum, :max_sum, :min_number_of_months,
                                     :max_number_of_months, :percent, :default_interest)
    end


  end
end
