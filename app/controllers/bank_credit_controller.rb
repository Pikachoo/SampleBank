class BankCreditController < ApplicationController

  def new
    @bank_credit_inputs =  {credit_type: 0, credit_type_another_car: "", credit_type_another_card: "",
      another_home_credit_type: "", issuance_method: 0, granted_procedure: 0, issuance_score: "",
      affirmation_of_commitments: 0, collateral_employee: 0, collateral_customer: 0, score_id: "", score_existance: 0,
      credit_sum: 0, credit_term: 0, credit_limit_term: 0, make_insurance: 0, repayment_method: 0
    }
    @bank_credit_inputs = flash[:inputs_params] if flash[:inputs_params] != nil
  end

  def create
    return redirect_to :back, flash: { validation_errors: validate, inputs_params: params[:bank_credit] }
  end

  def online_credit_params
    #params.require(:bank_credit).permit(:credit_type, :credit_type_another_car)
  end

  def validate
    validation_errors = []
    bankCredit = params[:bank_credit]
    #First step validation
    validation_errors.push "Выберите тип кредита на 1ом шаге." if bankCredit[:credit_type].to_i < 1 || bankCredit[:credit_type].to_i > 10
    validation_errors.push "Укажите вид финансирования недвижимости на 1ом шаге." if bankCredit[:credit_type].to_i == 4 && bankCredit[:another_home_credit_type] == ""
    validation_errors.push "Укажите вид автокредита на 1ом шаге." if bankCredit[:credit_type].to_i == 6 && bankCredit[:credit_type_another_car] == ""
    validation_errors.push "Укажите вид кредитных карт на 1ом шаге." if bankCredit[:credit_type].to_i == 8 && bankCredit[:credit_type_another_card] == ""
    validation_errors.push "Выберите порядок предоставления на 1ом шаге." if bankCredit[:granted_procedure].to_i < 1 || bankCredit[:granted_procedure].to_i > 3
    validation_errors.push "Выберите порядок обеспечения на 1ом шаге." if bankCredit[:affirmation_of_commitments].to_i < 1 || bankCredit[:affirmation_of_commitments].to_i > 13
    validation_errors.push "Выберите способ выдачи на 1ом шаге." if bankCredit[:issuance_method].to_i < 1 || bankCredit[:granted_procedure].to_i > 5
    validation_errors.push "Укажите наличие счёта в нашем банке на 1ом шаге." if bankCredit[:score_existance].to_i < 1 || bankCredit[:score_existance].to_i > 2
    validation_errors.push "Укажите номер счёта в нашем банке на 1ом шаге." if bankCredit[:score_existance].to_i == 1 && bankCredit[:account_id] == ""
    validation_errors.push "Укажите номер счёта получателя на 1ом шаге." if bankCredit[:issuance_method].to_i == 5 && bankCredit[:issuance_score] == ""
    validation_errors.push "Введите достоверную оценку залога клиентом на 1ом шаге." if bankCredit[:collateral_customer] != "" && bankCredit[:collateral_customer].to_i < 0
    validation_errors.push "Введите достоверную оценку залога служащим на 1ом шаге." if bankCredit[:collateral_employee] != "" && bankCredit[:collateral_employee].to_i < 0
    #End of first step validation

    #Second step validation
    validation_errors.push "Укажите сумму кредита на 2ом шаге." if bankCredit[:credit_sum].to_i < 1
    validation_errors.push "Укажите срок кредита на 2ом шаге." if bankCredit[:credit_term].to_i < 1
    validation_errors.push "Укажите срок освоения кредита на 2ом шаге." if bankCredit[:credit_limit_term].to_i < 1
    validation_errors.push "Укажите ответ на совокупный кредит на 2ом шаге." if bankCredit[:total_income].to_i < 1 || bankCredit[:total_income].to_i > 2
    validation_errors.push "Укажите будет ли клиент страховаться на 2ом шаге." if bankCredit[:make_insurance].to_i < 1 || bankCredit[:total_income].to_i > 2
    validation_errors.push "Укажите вид выплаты кредита на 2ом шаге." if bankCredit[:repayment_method].to_i < 1 || bankCredit[:total_income].to_i > 2
    #End of second step validation

    #Third step validation
    validation_errors.push "Укажите имя клиента на 3ем шаге." if bankCredit[:customer_firstname] == ""
    validation_errors.push "Укажите фамилию клиента на 3ем шаге." if bankCredit[:customer_lastname] == ""
    validation_errors.push "Укажите отчество клиента на 3ем шаге." if bankCredit[:customer_patronymic] == ""
    validation_errors.push "Укажите день рождения клиента на 3ем шаге." if bankCredit[:customer_birthdate] == ""
    validation_errors.push "Укажите идентификационный номер клиента на 3ем шаге." if bankCredit[:customer_id] == ""
    validation_errors.push "Укажите возраст клиента на 3ем шаге." if bankCredit[:customer_age] == "" || bankCredit[:customer_age].to_i < 1
    validation_errors.push "Укажите гражданство клиента на 3ем шаге." if bankCredit[:customer_country] == ""
    validation_errors.push "Укажите место рождения клиента на 3ем шаге." if bankCredit[:customer_birthplace] == ""
    validation_errors.push "Укажите семейное положение клиента на 3ем шаге." if bankCredit[:customer_family_status].to_i < 1 || bankCredit[:customer_family_status].to_i > 5
    validation_errors.push "Укажите жилищные условия клиента на 3ем шаге." if bankCredit[:customer_living_conditions].to_i < 1 || bankCredit[:customer_living_conditions].to_i > 8
    validation_errors.push "Укажите тип жилищных условий клиента на 3ем шаге." if bankCredit[:customer_living_conditions].to_i == 8 && bankCredit[:customer_another_living_conditions] == ""
    validation_errors.push "Укажите образование клиента на 3ем шаге." if bankCredit[:customer_education].to_i < 1 || bankCredit[:customer_education].to_i > 8
    validation_errors.push "Укажите отношение клиента к воинской службе на 3ем шаге." if bankCredit[:customer_military_conditions].to_i < 1 || bankCredit[:customer_military_conditions].to_i > 4
    validation_errors.push "Укажите дату отсрочки клиента от воинской службы на 3ем шаге." if bankCredit[:customer_military_conditions].to_i == 3 && bankCredit[:customer_reprieve_end_date] == ""
    validation_errors.push "Укажите информацию об имени клиента на 3ем шаге." if bankCredit[:customer_name_info].to_i < 1 || bankCredit[:customer_name_info].to_i > 2
    validation_errors.push "Укажите причину смены имени клиентом на 3ем шаге." if bankCredit[:customer_name_info].to_i == 1 && bankCredit[:customer_changing_reason] == ""
    validation_errors.push "Укажите наименование документа клиента на 3ем шаге." if bankCredit[:customer_document_type] == ""
    validation_errors.push "Укажите серию документа клиента на 3ем шаге." if bankCredit[:customer_document_series] == ""
    validation_errors.push "Укажите номер документа клиента на 3ем шаге." if bankCredit[:customer_document_number] == ""
    validation_errors.push "Укажите дату выдачи документа клиента на 3ем шаге." if bankCredit[:customer_document_given_date] == ""
    validation_errors.push "Укажите дату окончания документа клиента на 3ем шаге." if bankCredit[:customer_document_end_date] == ""
    validation_errors.push "Укажите адрес регистрации по месту жительства клиента на 3ем шаге." if bankCredit[:customer_registration_address] == ""
    validation_errors.push "Укажите адрес по месту пребывания клиента на 3ем шаге." if bankCredit[:customer_registration_place] == ""
    validation_errors.push "Укажите адрес фактического места проживания клиента на 3ем шаге." if bankCredit[:customer_actual_living_place] == ""
    validation_errors.push "Укажите срок проживания по месту фактического проживания клиента на 3ем шаге." if bankCredit[:customer_living_age].to_i < 1

    #End of third step validation

    validation_errors == [] ? nil : validation_errors
  end
end
