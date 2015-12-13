class CreditAdministrateController < ApplicationController
  before_filter :check_is_manage

  def check_is_manage
    raise() if User.find(session[:user_id]).role_id != 2
  end

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
    ClientCredit.find(params[:id]).update_attributes(credit_state: 3)
    return redirect_to credit_administrate_index_path
  end

  def applyment_confirmation
    ClientCredit.find(params[:id]).update_attributes(credit_state: 1, begin_date: Date.today)
    return redirect_to credit_administrate_index_path
  end

  def applyment_decline
    ClientCredit.find(params[:id]).update_attributes(credit_state: 4)
    return redirect_to credit_administrate_index_path
  end
end

