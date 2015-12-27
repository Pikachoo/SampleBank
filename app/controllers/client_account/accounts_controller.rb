module ClientAccount
  class AccountsController < ApplicationController
    load_and_authorize_resource
    # skip_authorize_resource :only => :show_account

    def show
      flash[:notice] = nil
      @current_page = params[:accounts_credits].to_i
      cur_date = Timemachine.get_current_date  + 1.day
      puts cur_date
      client_credits = current_client.client_credits.where("begin_date <= '#{cur_date}' and credit_state = 1")
      account_ids = Array.new
      client_credits.each do |credit|
        account_ids.push credit.account_id
      end
      @accounts = current_client.accounts.where("created_date <= '#{cur_date}' and id IN (#{account_ids.join(',')})").page(params[:accounts_credits])
    end

    def show_account
      operations = ClientOperation.where(:account_id => params[:id])
      if operations
        @operations = operations.order(date: :desc)
      else
        @operations = nil
      end
    end

    def update

      sms_ids = params[:sms_ids]
      emails_ids = params[:emails_ids]
      @current_page = params[:accounts_credits].to_i
      @accounts = current_client.accounts.page(params[:accounts_credits])

      @accounts.each do |account|
        if sms_ids
          if sms_ids.index(account.id.to_s)
            account.is_sms = true
          else
            account.is_sms = false
          end
        else
          account.is_sms = false
        end

        if emails_ids
          if emails_ids.index(account.id.to_s)
            account.is_email = true
          else
            account.is_email = false
          end
        else
          account.is_email = false
        end

        account.save
      end

      flash[:notice] = 'Изменения сохранены'
      render 'client_account/accounts/show'
    end
  end
end
