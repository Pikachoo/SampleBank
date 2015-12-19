module ClientAccount
  class AccountsController < ApplicationController
    load_and_authorize_resource
    # skip_authorize_resource :only => :show_account

    def show
      flash[:notice] = nil
      @accounts = current_client.accounts
    end

    def show_account
      puts 'adsffd'
      @account = Account.find(params[:id])
    end
    def update

      sms_ids = params[:sms_ids]
      emails_ids = params[:emails_ids]

      @accounts = current_client.accounts

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
