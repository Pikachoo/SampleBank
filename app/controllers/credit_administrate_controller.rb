class CreditAdministrateController < ApplicationController
  before_filter :check_is_manage

  def check_is_manage
    raise() if User.find(session[:user_id]).role_id != 2
  end

  def index
    @applyment_credits = ClientCredit.where(credit_state: 0)
    @opened_credits = ClientCredit.where(credit_state: 1)
    @closed_credits = ClientCredit.where(credit_state: 3)
    @declined_credits = ClientCredit.where(credit_state: 4)
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

