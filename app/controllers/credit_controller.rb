class CreditController < ApplicationController
  def get_extra_information_by_id
    id = params[:id]
    information = Hash.new

    credit = Credit.find(id)

    information[:payments] = credit.get_credit_payments
    information[:warrenties] = credit.get_credit_warrenties
    information[:grantings] = credit.get_credit_grantings

    render json: information
  end
end
