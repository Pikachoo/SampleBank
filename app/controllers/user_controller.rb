class UserController < ApplicationController

  def index
    @cards = Account.all
    render  json: @cards
  end

  def new
    @user = User.new
  end

  def create
    identifical_number = params[:identifical_number]
    password = params[:password]
    password_confirmation = params[:password_confirmation]

    if password != password_confirmation
      flash[:notice] = 'Пароли не совпадают';
    end
    @user =  User.create_client_user_account(identifical_number, password)

    if flash.nil?
      if @user.save
        redirect_to root_url, :notice => "Пользователь зарегистрирован."
      end
    else
      flash.now.alert = @user.error_message
      render "new"
    end
  end

  private

  def user_params
    params.require(:user).permit(:name,  :password, :password_confirmation)
  end
end
