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

    #Fourth step validation
    validation_errors.push "Укажите тип работы клиента на 4ом шаге." if bankCredit[:customer_employment_type].to_i < 1 || bankCredit[:customer_employment_type].to_i > 11
    if bankCredit[:customer_employment_type].to_i != 10 then
      validation_errors.push "Укажите место практики клиента на 4ом шаге." if bankCredit[:customer_employment_type] == "9" && bankCredit[:customer_practical_employment] == ""
      validation_errors.push "Укажите тип занятости клиента на 4ом шаге." if bankCredit[:customer_employment_type] == "11" && bankCredit[:customer_another_employment] == ""
      validation_errors.push "Укажите начало работы клиента на 4ом шаге." if bankCredit[:customer_start_job_date] == ""
      validation_errors.push "Укажите конец контракта клиента на 4ом шаге." if bankCredit[:customer_end_job_date] == ""
      validation_errors.push "Укажите наименование организации клиента на 4ом шаге." if bankCredit[:customer_organization_name] == ""
      validation_errors.push "Укажите должность работы клиента на 4ом шаге." if bankCredit[:customer_job_name] == ""
      validation_errors.push "Укажите адрес работы клиента на 4ом шаге." if bankCredit[:customer_organization_address] == ""
      validation_errors.push "Укажите сферу деятельности клиента на 4ом шаге." if bankCredit[:customer_activity_status].to_i < 1 || bankCredit[:customer_activity_status].to_i > 38
      validation_errors.push "Укажите численность рабочих на 4ом шаге." if bankCredit[:customer_employers_count].to_i < 1 || bankCredit[:customer_employers_count].to_i > 6
      validation_errors.push "Укажите стаж работы на 4ом шаге." if bankCredit[:customer_experience_in_organization].to_i < 1 || bankCredit[:customer_experience_in_organization].to_i > 7
      validation_errors.push "Укажите категорию занимаемой должности на 4ом шаге." if bankCredit[:customer_job_category].to_i < 1 || bankCredit[:customer_job_category].to_i > 10
      validation_errors.push "Укажите процент от доходов предприятия на 4ом шаге." if bankCredit[:customer_job_category].to_i == 9 && (bankCredit[:customer_owners_percent].to_f <= 0.0 || bankCredit[:customer_owners_percent].to_f > 100)
    end
    #End of fourth step validation

    #Fifth step validation
    validation_errors.push "Укажите тип работы клиента на 5ом шаге." if bankCredit[:customer_additional_employment_type].to_i < 1 || bankCredit[:customer_additional_employment_type].to_i > 11
    if bankCredit[:customer_additional_employment_type].to_i != 10 then
      validation_errors.push "Укажите место практики клиента на 5ом шаге." if bankCredit[:customer_additional_employment_type] == "9" && bankCredit[:customer_additional_practical_employment] == ""
      validation_errors.push "Укажите тип занятости клиента на 5ом шаге." if bankCredit[:customer_additional_employment_type] == "11" && bankCredit[:customer_additional_another_employment] == ""
      validation_errors.push "Укажите начало работы клиента на 5ом шаге." if bankCredit[:customer_additional_start_job_date] == ""
      validation_errors.push "Укажите конец контракта клиента на 5ом шаге." if bankCredit[:customer_additional_end_job_date] == ""
      validation_errors.push "Укажите наименование организации клиента на 5ом шаге." if bankCredit[:customer_additional_organization_name] == ""
      validation_errors.push "Укажите должность работы клиента на 5ом шаге." if bankCredit[:customer_additional_job_name] == ""
      validation_errors.push "Укажите адрес работы клиента на 5ом шаге." if bankCredit[:customer_additional_organization_address] == ""
      validation_errors.push "Укажите сферу деятельности клиента на 5ом шаге." if bankCredit[:customer_additional_activity_status].to_i < 1 || bankCredit[:customer_additional_activity_status].to_i > 38
      validation_errors.push "Укажите численность рабочих на 5ом шаге." if bankCredit[:customer_additional_employers_count].to_i < 1 || bankCredit[:customer_additional_employers_count].to_i > 6
      validation_errors.push "Укажите стаж работы на 5ом шаге." if bankCredit[:customer_additional_experience_in_organization].to_i < 1 || bankCredit[:customer_additional_experience_in_organization].to_i > 7
      validation_errors.push "Укажите категорию занимаемой должности на 5ом шаге." if bankCredit[:customer_additional_job_category].to_i < 1 || bankCredit[:customer_additional_job_category].to_i > 10
      validation_errors.push "Укажите процент от доходов предприятия на 5ом шаге." if bankCredit[:customer_additional_job_category].to_i == 9 && (bankCredit[:customer_additional_owners_percent].to_f <= 0.0 || bankCredit[:customer_owners_percent].to_f > 100)
    end
    #End of fifth step validation

    #Sixth step validation (3 - 4)
    if bankCredit[:customer_family_status].to_i == 3 || bankCredit[:customer_family_status].to_i == 4
      validation_errors.push "Укажите имя супруга клиента на 6ом шаге." if bankCredit[:partner_firstname] == ""
      validation_errors.push "Укажите фамилию супруга клиента на 6ом шаге." if bankCredit[:partner_lastname] == ""
      validation_errors.push "Укажите отчество супруга клиента на 6ом шаге." if bankCredit[:partner_patronymic] == ""
      validation_errors.push "Укажите день рождения супруга клиента на 6ом шаге." if bankCredit[:partner_birthdate] == ""
      validation_errors.push "Укажите идентификационный номер супруга клиента на 6ом шаге." if bankCredit[:partner_id] == ""
      validation_errors.push "Укажите возраст супруга клиента на 6ом шаге." if bankCredit[:partner_age] == "" || bankCredit[:partner_age].to_i < 1
      validation_errors.push "Укажите гражданство супруга клиента на 6ом шаге." if bankCredit[:partner_country] == ""
      validation_errors.push "Укажите место рождения супруга клиента на 6ом шаге." if bankCredit[:partner_birthplace] == ""
      validation_errors.push "Укажите семейное положение супруга клиента на 6ом шаге." if bankCredit[:partner_family_status].to_i < 1 || bankCredit[:partner_family_status].to_i > 5
      validation_errors.push "Укажите жилищные условия супруга клиента на 6ом шаге." if bankCredit[:partner_living_conditions].to_i < 1 || bankCredit[:partner_living_conditions].to_i > 8
      validation_errors.push "Укажите тип жилищных условий супруга клиента на 6ом шаге." if bankCredit[:partner_living_conditions].to_i == 8 && bankCredit[:partner_another_living_conditions] == ""
      validation_errors.push "Укажите образование супруга клиента на 6ом шаге." if bankCredit[:partner_education].to_i < 1 || bankCredit[:partner_education].to_i > 8
      validation_errors.push "Укажите отношение супруга клиента к воинской службе на 6ом шаге." if bankCredit[:partner_military_conditions].to_i < 1 || bankCredit[:partner_military_conditions].to_i > 4
      validation_errors.push "Укажите дату отсрочки супруга клиента от воинской службы на 6ом шаге." if bankCredit[:partner_military_conditions].to_i == 3 && bankCredit[:partner_reprieve_end_date] == ""
      validation_errors.push "Укажите информацию об имени супруга клиента на 6ом шаге." if bankCredit[:partner_name_info].to_i < 1 || bankCredit[:partner_name_info].to_i > 2
      validation_errors.push "Укажите причину смены имени супруга клиента на 6ом шаге." if bankCredit[:partner_name_info].to_i == 1 && bankCredit[:partner_changing_reason] == ""
      validation_errors.push "Укажите наименование документа супруга клиента на 6ом шаге." if bankCredit[:partner_document_type] == ""
      validation_errors.push "Укажите серию документа супруга клиента на 6ом шаге." if bankCredit[:partner_document_series] == ""
      validation_errors.push "Укажите номер документа супруга клиента на 6ом шаге." if bankCredit[:partner_document_number] == ""
      validation_errors.push "Укажите дату выдачи документа супруга клиента на 6ом шаге." if bankCredit[:partner_document_given_date] == ""
      validation_errors.push "Укажите дату окончания документа супруга клиента на 6ом шаге." if bankCredit[:partner_document_end_date] == ""
      validation_errors.push "Укажите адрес регистрации по месту жительства супруга клиента на 6ом шаге." if bankCredit[:partner_registration_address] == ""
      validation_errors.push "Укажите адрес по месту пребывания супруга клиента на 6ом шаге." if bankCredit[:partner_registration_place] == ""
      validation_errors.push "Укажите адрес фактического места проживания супруга клиента на 6ом шаге." if bankCredit[:partner_actual_living_place] == ""
      validation_errors.push "Укажите срок проживания по месту фактического проживания супруга клиента на 6ом шаге." if bankCredit[:partner_living_age].to_i < 1
      validation_errors.push "Укажите организации работы супруга клиента на 6ом шаге." if bankCredit[:partner_organization_name] == ""
      validation_errors.push "Укажите должность супруга клиента на 6ом шаге." if bankCredit[:partner_job_name] == ""
      validation_errors.push "Укажите адрес организации супруга клиента на 6ом шаге." if bankCredit[:partner_organization_address] == ""
    end
    #End of sixth step validation

    validation_errors == [] ? nil : validation_errors
  end
end
