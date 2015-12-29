class SessionController < ApplicationController
  def new
  end

  def create
    user = User.authenticate(params[:name], params[:password])
    puts json: user
    if user
      session[:user_id] = user.id
      if user.is? 'operator'
        redirect_to new_bank_credit_path
      elsif user.is? 'user_admin'
        redirect_to operator_users_path
      elsif user.is? 'credit_admin'
        redirect_to operator_credits_path
      elsif user.is? 'cashier'
        redirect_to new_cashier_credit_payment_path
      else
        redirect_to root_url, :notice => "Вошли"
      end

    else
      flash[:error] = "Неправильный пароль и логин"
      render "new"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Logged out!"
  end
end
