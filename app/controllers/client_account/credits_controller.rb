module ClientAccount
  class CreditsController < ApplicationController
    load_and_authorize_resource :client_credit
    load_and_authorize_resource :account

    def show
      flash[:notice] = nil
      @client_credits = current_client.client_credits
      if @client_credits.empty?
        flash[:notice] = 'У клиента нет кредитов.'
      end
      puts json: @client_credits
    end

    def show_credit
      @client_credit_id = params[:id]
      client_credit = ClientCredit.find_by(id: @client_credit_id)
      @paymens_params = ClientCredit.credit_payments(client_credit)
    end
  end
end
