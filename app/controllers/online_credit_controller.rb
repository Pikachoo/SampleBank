class OnlineCreditController < ApplicationController

  def new
    @online_credit_inputs =  {"credit_product_type"=>"0", "currency_type"=>"0", "sum_value"=>"0", "term_loan_product"=>"0", "provision_type"=>"0", "other_provision_type"=>"", "organization_name"=>"dhghf", "customers_address"=>"", "main_activity_type"=>"0", "alt_main_activity"=>"", "organization_experience"=>"", "customers_firstname"=>"", "customers_lastname"=>"", "customers_patronymic"=>"", "customers_phone"=>"", "customers_email"=>"" }
    @online_credit_inputs = flash[:inputs_params] if flash[:inputs_params] != nil
  end

  def index
  end

  def create
    #@online_credit = OnlineCredit.new(online_credit_params)
    return redirect_to :back, params: params, flash: { validation_errors: validate, inputs_params: params[:online_credit] }
  end

  def online_credit_params
    params.require(:online_credit).permit(:organization_name,
        :customers_address, :main_activity_type, :alt_main_activity, :organization_experience,
        :customers_firstname, :customers_lastname, :customers_patronymic, :customers_phone, :customers_email)
  end

  def validate
    validation_errors = []
    onlineCredit = params[:online_credit]
    validation_errors.push "Выберите тип кредита на 1ом шаге." if onlineCredit[:credit_product_type].to_i <= 0 || onlineCredit[:credit_product_type].to_i > 5
    validation_errors.push "Выберите валюту 2ом шаге." if onlineCredit[:currency_type].to_i <= 0 || onlineCredit[:currency_type].to_i > 3
    validation_errors.push "Введите сумму кредита большую нуля на 3ем шаге." if onlineCredit[:sum_value].to_i <= 0
    validation_errors.push "Введите срок кредита в месяцах на 4ом шаге." if onlineCredit[:term_loan_product].to_i <= 0
    validation_errors.push "Введите виды обеспечения на 5ом шаге." if onlineCredit[:other_provision_type] == "" && onlineCredit[:provision_type] == "0"
    validation_errors.push "Введите имя вашей организации на 6ом шаге." if onlineCredit[:organization_name] == ""
    validation_errors.push "Введите ваш адрес проживания на 6ом шаге." if onlineCredit[:customers_address] == ""
    validation_errors.push "Введите вид вашей деятельности на 6ом шаге." if (onlineCredit[:main_activity_type].to_i == 0 && onlineCredit[:alt_main_activity] == "") || onlineCredit[:main_activity_type].to_i > 5
    validation_errors.push "Введите ваш опыт работы на 6ом шаге." if onlineCredit[:organization_experience].to_i <= 0
    validation_errors.push "Введите ваш опыт работы на 6ом шаге." if onlineCredit[:organization_experience].to_i <= 0
    validation_errors.push "Введите ваш опыт работы на 6ом шаге." if onlineCredit[:organization_experience].to_i <= 0
    validation_errors.push "Введите ваш имя на 6ом шаге." if onlineCredit[:customers_firstname] == ""
    validation_errors.push "Введите ваш фамилию на 6ом шаге." if onlineCredit[:customers_lastname] == ""
    validation_errors.push "Введите ваш отчество на 6ом шаге." if onlineCredit[:customers_patronymic] == ""
    validation_errors.push "Введите ваш мобильный телефон на 6ом шаге." if onlineCredit[:customers_phone] == ""
    validation_errors == [] ? nil : validation_errors
  end
end
