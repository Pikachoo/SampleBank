module Operator
  class UsersController < ApplicationController
    load_and_authorize_resource
    skip_load_resource :only => :create
    rescue_from ActiveRecord::RecordNotFound do |exception|
      @client_users = User.where(role_id: 1).page(params[:client_users_page].to_i)
      @operator_users = User.where(role_id: 2).page(params[:operator_users_page].to_i)
      @error_message = 'Пользователь не найден'
      render 'operator/users/index'
    end

    def index
      @client_users = User.where(role_id: 1).order(:name).page(params[:client_users_page].to_i)
      @operator_users = User.where(role_id: 2).order(:name).page(params[:operator_users_page].to_i)
      @cashier_users = User.where(role_id: 5).order(:name).page(params[:cashier_users].to_i)
      @user_admin_users = User.where(role_id: 3).order(:name).page(params[:user_admin_users].to_i)
      @credit_admin_users = User.where(role_id: 4).order(:name).page(params[:credit_admin_users].to_i)
    end

    def new
      @user_inputs = {name: '', role_id: 0}
      @user_inputs = flash[:inputs_params] if flash[:inputs_params] != nil
    end

    def create
      @user = User.new(user_params)
      @user.save_first_time
      @user_inputs = {name: @user.name, role_id: @user.role_id}
      redirect_to :back, flash: {validation_errors: @user.error_message,
                                 inputs_params: params[:user]} unless @user.error_message.nil?
    end

    def edit
      @user = User.find(params[:id])
    end

    def update_password
      @user = User.find(params[:id])
      @user.generate_password
      @user.save
      @user.send_email("Пароль был изменен.\nПользователь\n имя: #{@user.name}\n новый пароль: #{@user.password}")
      @user.send_sms("Пароль был изменен.\nПользователь\n имя: #{@user.name}\n новый пароль: #{@user.password}")
    end
    def update
      @user.update(user_params)

      @client_users = User.where(role_id: 1).order(:name).page(params[:client_users_page].to_i)
      @operator_users = User.where(role_id: 2).order(:name).page(params[:operator_users_page].to_i)
      @cashier_users = User.where(role_id: 5).order(:name).page(params[:cashier_users].to_i)
      @user_admin_users = User.where(role_id: 3).order(:name).page(params[:user_admin_users].to_i)
      @credit_admin_users = User.where(role_id: 4).order(:name).page(params[:credit_admin_users].to_i)
      @message = 'Пользователь обновлен.'
      render 'operator/users/index'
    end

    def destroy
      begin
        user = User.find(params[:id])
        user.send_email("Пользователь с именем #{user.name} был удален")
        user.send_sms("Пользователь с именем #{user.name} был удален")
        user.destroy

        @client_users = User.where(role_id: 1).order(:name).page(params[:client_users_page].to_i)
        @operator_users = User.where(role_id: 2).order(:name).page(params[:operator_users_page].to_i)
        @cashier_users = User.where(role_id: 5).order(:name).page(params[:cashier_users].to_i)
        @user_admin_users = User.where(role_id: 3).order(:name).page(params[:user_admin_users].to_i)
        @credit_admin_users = User.where(role_id: 4).order(:name).page(params[:credit_admin_users].to_i)
        @message = 'Пользователь удален.'
        render 'operator/users/index'
      end
    end

    private
    def user_params
      params.require(:user).permit(:name, :role_id)
    end
  end
end
