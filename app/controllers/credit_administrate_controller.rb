class CreditAdministrateController < ApplicationController
  load_and_authorize_resource :client_credit

  # def check_is_manage
  #   raise() if User.find(session[:user_id]).role_id == 1
  # end

  def index
    @applyment_credits = ClientCredit.where(credit_state: 0).page(params[:applyment_credits_page].to_i)
    @opened_credits = ClientCredit.where(credit_state: 1).page(params[:opened_credits_page].to_i)
    @closed_credits = ClientCredit.where(credit_state: 3).page(params[:closed_credits_page].to_i)
    @declined_credits = ClientCredit.where(credit_state: 4).page(params[:declined_credits_page].to_i)
  end

  def applyment
    @client_credit = ClientCredit.find(params[:id])
  end

  def current_credit
    @client_credit = ClientCredit.find(params[:id])
  end

  def close
    client_credit = ClientCredit.find(params[:id])
    if client_credit.credit_state == 1
      client_credit.update_state(3)
      redirect_to credit_administrate_index_path, flash: {validation_messages: ["Кредит №#{params[:id]}  закрыт."]}
    else
      redirect_to credit_administrate_index_path, flash: {validation_errors: ["Кредит №#{params[:id]} уже был закрыт."]}
    end
  end

  def applyment_confirmation
    @client_credit = ClientCredit.find(params[:id])
    if @client_credit.credit_state == 0
      result = @client_credit.update_state(1)
      @account = result[:account]
      @user = result[:user]
      @card = result[:card]

      render 'credit_administrate/confirmation_info'
    else
      redirect_to credit_administrate_index_path, flash: {validation_errors: ["Кредит №#{params[:id]} уже одобрен."]}
    end

  end

  def applyment_decline
    client_credit = ClientCredit.find(params[:id])
    if client_credit.credit_state == 0
      client_credit.update_attributes(credit_state: 4)
      redirect_to credit_administrate_index_path, flash: {validation_messages: ["Кредит №#{params[:id]}  откланен."]}
    else
      redirect_to credit_administrate_index_path, flash: {validation_errors: ["Кредит №#{params[:id]} уже был рассмотрен."]}
    end

  end

  def print_credit
    @credit = ClientCredit.where(id: params[:id]).first
    @client = Client.where(id: @credit.client_id).first
    @user = User.find(session[:user_id])
    @employee = BankEmployee.where(user_id: @user.id).first
    @role = Role.where(id: @user.role_id).first.name
    @credit_info = Credit.where(id: @credit.credit_id).first
  end

end

