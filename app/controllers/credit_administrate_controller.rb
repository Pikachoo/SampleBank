class CreditAdministrateController < ApplicationController

  def index
    @applyment_credits = ClientCredit.where(credit_state: 0)
    @opened_credits = ClientCredit.where(credit_state: 1)
    @closed_credits = ClientCredit.where(credit_state: 3)
    @declined_credits = ClientCredit.where(credit_state: 4)
  end

  def applyment
    @credit = ClientCredit.where(id: params[:id]).first
    @client = Client.where(id: @credit.client_id).first
    @credit_type = (Credit.where(id: @credit.credit_id).first).name
  end

  def current_credit
    @credit = ClientCredit.where(id: params[:id]).first
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

