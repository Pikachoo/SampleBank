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

      #создание сотрудника банка
      employee_name = params[:user][:man_name]
      employee_surname = params[:user][:man_surname]
      employee_patronymic = params[:user][:man_patronymic]
      employee_mobile_phone = params[:user][:man_mobile_phone]
      employee_email = params[:user][:man_email]
      bank_employee = BankEmployee.create(name: employee_name,
                                          surname: employee_surname,
                                          patronymic: employee_patronymic,
                                          email: employee_email,
                                          mobile_phone: employee_mobile_phone)
      # создание пользователя
      @user = User.new(user_params)
      @user = @user.save_user_employee(bank_employee)

      #обновление связи user и bank_employee
      bank_employee.update_attributes(user_id: @user.id)

      @user_inputs = {name: @user.name,
                      role_id: @user.role_id,
                      man_name: employee_name,
                      man_surname: employee_surname,
                      man_patronymic: employee_patronymic,
                      man_mobile_phone: employee_mobile_phone,
                      man_email: employee_email}

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
      @user.send_email("Пароль был изменен. Логин: #{@user.name}, новый пароль: #{@user.password}.")
      @user.send_sms("Пароль был изменен. Логин: #{@user.name}, новый пароль: #{@user.password}.")
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
        @message = 'Пользователь удален.'
        if user.id != current_user.id
          user.send_email("Пользователь с именем #{user.name} был удален.")
          user.send_sms("Пользователь с именем #{user.name} был удален.")
          user.destroy
        else
          @message = 'Вы не может удалить себя.'
        end

        @client_users = User.where(role_id: 1).order(:name).page(params[:client_users_page].to_i)
        @operator_users = User.where(role_id: 2).order(:name).page(params[:operator_users_page].to_i)
        @cashier_users = User.where(role_id: 5).order(:name).page(params[:cashier_users].to_i)
        @user_admin_users = User.where(role_id: 3).order(:name).page(params[:user_admin_users].to_i)
        @credit_admin_users = User.where(role_id: 4).order(:name).page(params[:credit_admin_users].to_i)

        render 'operator/users/index'
      end
    end

    private
    def user_params
      params.require(:user).permit(:name, :role_id)
    end
  end
end
