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
      credit.save_credit(params[:credit][:warrenty_type],  params[:credit][:granting_type],  params[:credit][:payment_type])

      @credits = Credit.all
      render 'operator/credits/index'
    end

    def edit

      @credit = Credit.find(params[:id])
    end
    def update
      @credit.update(credit_params)
      @credit.update_dependecies(params[:credit][:warrenty_type],  params[:credit][:granting_type],  params[:credit][:payment_type])
      @credits = Credit.all
      render 'operator/credits/index'
    end

    def destroy
      credit = Credit.find(params[:id])
      credit.destroy_credit
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
