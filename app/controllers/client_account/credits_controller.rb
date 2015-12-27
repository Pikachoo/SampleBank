module ClientAccount
  class CreditsController < ApplicationController
    load_and_authorize_resource :client_credit
    load_and_authorize_resource :account

    def show
      flash[:notice] = nil
      @current_page = params[:client_cards].to_i
      cur_date = Timemachine.get_current_date+ 1.day
      puts cur_date
      @client_credits = current_client.client_credits.where("begin_date <= '#{cur_date}' and credit_state = 1").page(params[:client_credits].to_i)
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
