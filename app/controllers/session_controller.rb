class SessionController < ApplicationController
  def new
  end
  def create
    user = User.authenticate(params[:name], params[:password])
    puts json: user
    if user
      session[:user_id] = user.id
      redirect_to root_url, :notice => "Вошли"
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
