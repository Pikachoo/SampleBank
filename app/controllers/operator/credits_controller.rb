module Operator
  class CreditsController < ApplicationController
    load_and_authorize_resource
    skip_load_resource :create, :update
    rescue_from ActiveRecord::RecordNotFound do |exception|
      @message = 'Кредит не найден'
      redirect_to operator_credits_path, flash: {message: @message}
    end

    def index
      @credits = Credit.where(is_active: true)
      @message = flash[:message] if flash[:message] != nil
    end

    def new

    end

    def create

      credit = Credit.new(credit_params)
      credit.currency_id = params[:credit][:currency]
      @message = credit.save_credit_and_dependecies(params[:credit][:warrenty_type], params[:credit][:granting_type], params[:credit][:payment_type])

      redirect_to operator_credits_path, flash: {message: @message}
    end

    def edit
      @credit = Credit.find(params[:id])
    end

    def update

      @credit = @credit.custom_update(credit_params, params[:credit][:warrenty_type], params[:credit][:granting_type], params[:credit][:payment_type])


      @message = 'Кредит обновлен.'
      unless @credit.error_message.nil?
        redirect_to :back, flash: {validation_errors: @credit.error_message,
                                   inputs_params: params[:user]}
      else

        redirect_to operator_credits_path, flash: {message: @message}
      end
    end

    def destroy
      credit = Credit.find(params[:id])
      credit.destroy_credit_and_dependecies

      @message = 'Кредит удален.'
      redirect_to operator_credits_path, flash: {message: @message}

    end

    private
    def credit_params
      params.require(:credit).permit(:name, :min_sum, :max_sum, :min_number_of_months,
                                     :max_number_of_months, :percent, :default_interest)
    end


  end
end
