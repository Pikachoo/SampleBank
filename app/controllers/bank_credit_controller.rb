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
    validation_errors = validate
    return redirect_to :back, flash: { validation_errors: validate, inputs_params: params[:bank_credit] } if validation_errors != nil
    @mark, @necessaryMark, @mark_explanations, @calculating, @isCollateralEmployed, @creditSum = calculate_mark
  end

  def calculate_mark
    mark = 1.0
    necessaryMark = 0
    mark_explanations = []
    calculating = ""
    bankCredit = params[:bank_credit]
    collateral_employee = 0
    collateralEmployed = false
    calculatedMark = "("

    #First step mark
    case bankCredit[:credit_type].to_i
      when 3, 5, 9
        mark *= 1.2
        mark_explanations.push "Коэфициент предоставленного кредита составляет 1.2"
        calculating += "(1.2"
      when 2
        mark *= 1.12
        mark_explanations.push "Коэфициент предоставленного кредита на приобретения жилья составляет 1.12"
        calculating += "(1.12"
      else
        mark *= 0.95
        mark_explanations.push "Коэфициент предоставленного кредита составляет 0.95"
        calculating += "(0.95"
    end

    case bankCredit[:granted_procedure].to_i
      when 1
        mark += 0.05
        mark_explanations.push "Выбран единовременный порядок предоставления, добавлен коэфициент равный 0.05"
        calculating += "+0.05)"
      when 2
        mark += 0.07
        mark_explanations.push "Выбрана невозобновляемая кредитная линия, добавлен коэфициент равный 0.07"
        calculating += "+0.07)"
      when 3
        mark += 0.1
        mark_explanations.push "Выбран невозобновляемая кредитная линия с использованием банковской карты, добавлен коэфициент равный 0.1"
        calculating += "+0.1)"
    end

    case bankCredit[:issuance_method].to_i
      when 1, 3, 4
        mark *= 1.1
        mark_explanations.push "Коэфициент способа выдачи равнен 1.1"
        calculating += "*1.1"
      else
        mark *= 0.98
        mark_explanations.push "Коэфициент способа выдачи равнен 0.98"
        calculating += "*0.98"
    end

    case bankCredit[:affirmation_of_commitments].to_i
      when 10, 11, 12
        mark *= 1.1
        mark_explanations.push "Коэфициент обеспечения кредитных обязательств равнен 1.1"
        calculating += "*1.1"
      when 7, 6, 4, 9
        mark *= 1.05
        mark_explanations.push "Коэфициент обеспечения кредитных обязательств равнен 1.05"
        calculating += "*1.05"
      else
        mark *= 0.9
        mark_explanations.push "Коэфициент обеспечения кредитных обязательств равнен 0.9"
        calculating += "*0.9"
    end

    if bankCredit[:account_id].to_i == 1
      mark *= 1.05
      mark_explanations.push ["Ввиду наличия в нашем банке счёта, добавночный коэфициент будет равен 1.05"]
      calculating += "*1.05"
    end

    collateral_employee = bankCredit[:collateral_employee].to_i if bankCredit[:collateral_employee] != 0
    #End of first step mark

    #Second step mark
    creditSum = bankCredit[:credit_sum].to_f
    necessaryMark = creditSum / 2000000000.0

    mark_explanations.push "Необходимая оценка равна #{necessaryMark}"

    mark *= bankCredit[:credit_term].to_f / 12.0
    mark_explanations.push "Добавночный коэфициент для срока кредита будет равен #{(bankCredit[:credit_term].to_f / 12.0).round(2)}"
    calculating += "*#{(bankCredit[:credit_term].to_f / 12.0).round(2)}"

    case bankCredit[:make_insurance].to_i
      when 1
        mark *= 1.1
        mark_explanations.push "Добавночный коэфициент в связи со страховкой равен 1.1"
        calculating += "*1.1"
      when 2
        mark *= 0.7
        mark_explanations.push "Добавночный коэфициент в виду отсутствия страховки равен 0.7"
        calculating += "*0.7"
    end

    if bankCredit[:repayment_method].to_i == 2
      mark *= 1.05
      mark_explanations.push "Добавночный коэфициент погашения равными долями равен 1.05"
      calculating += "*1.05"
    end
    #End of second step mark

    #Third step mark
    case bankCredit[:customer_living_conditions].to_i
      when 1
        mark *= 1.15
        mark_explanations.push "В связи с наличием собственной квартиры коэфициент равен 1.15"
        calculating += "*1.15"
      when 2
        mark *= 0.95
        mark_explanations.push "Коэфициент съёмной квартиры равен 0.9"
        calculating += "*0.9"
      else
        mark *= 0.7
        mark_explanations.push "Коэфициент жилищных условий 0.7"
        calculating += "*0.7"
    end

    case bankCredit[:customer_education].to_i
      when 6
        mark *= 1.02
        mark_explanations.push "Коэфициент образования равен 1.02"
        calculating += "*1.02"
      when 7, 8
        mark *= 1.04
        mark_explanations.push "Коэфициент образования равен 1.04"
        calculating += "*1.04"
      else
        mark *= 0.98
        mark_explanations.push "Коэфициент образования равен 0.98"
        calculating += "*0.98"
    end

    case bankCredit[:customer_military_conditions].to_i
      when 1, 2
        mark_explanations.push "Коэфициент отношения к воинской службе равен 1"
        calculating += "*1"
      else
        mark *= 0.93
        mark_explanations.push "Коэфициент отношения к воинской службе равен 0.93"
        calculating += "*0.93"
    end

    if bankCredit[:customer_age].to_i < 18
      mark *= -1
      mark_explanations.push "Ввиду несовершеннолетия клиента мы не можем выдать ему кредит."
      calculating += "*-1"
    end
    #End of third step mark

    #Fourth step mark
    case bankCredit[:customer_employment_type].to_i
      when 10
        mark *= 0.01
        mark_explanations.push "Ввиду Отсутствия работы коэфициент кредита равен 0.1"
        calculating += "*0.1"
      when 9
        mark *= 0.2
        mark_explanations.push "Ввиду частной практики коэфициент кредита равен 0.2"
        calculating += "*0.2"
      when 4
        mark *= 0.05
        mark_explanations.push "Ввиду того что клиент пенсионер коэфициент кредита равен 0.4"
        calculating += "*0.4"
      when 3, 5
        mark *= 1.1
        mark_explanations.push "Коэфициент кредита по работе равен 1.1"
        calculating += "*1.1"
      else
        mark *= 0.91
        mark_explanations.push "Коэфициент кредита по работе равен 0.91"
        calculating += "*0.91"
    end

    if bankCredit[:customer_employment_type].to_i != 10 && bankCredit[:customer_employment_type].to_i != 4
      case bankCredit[:customer_activity_status].to_i
        when 38, 15, 17, 34, 35
          mark *= 1.2
          mark_explanations.push "Коэфициент сферы деятельности равен 1.2"
          calculating += "*1.2"
        else
          mark *= 0.95
          mark_explanations.push "Коэфициент сферы деятельности равен 0.95"
          calculating += "*0.95"
      end

      case bankCredit[:customer_job_category].to_i
        when 4, 5, 8
          mark *= 1.2
          mark_explanations.push "Коэфициент занимаемой должности равен 1.2"
          calculating += "*1.2"
        when 9
          percent = bankCredit[:customer_owners_percent].to_f
          mark *= 1.0 + percent / 10.0
          mark_explanations.push "Коэфициент занимаемой должности владельца предприятия равен #{1.0 + percent / 10.0}"
          calculating += "*#{1.0 + percent / 10.0}"
        else
          mark *= 0.95
          mark_explanations.push "Коэфициент занимаемой должности равен 0.95"
          calculating += "*0.95"
      end

      job_changing_coeficient = 1.0 - bankCredit[:customer_job_changing_value].to_i / 30.0
      if job_changing_coeficient != 0
        mark *= job_changing_coeficient
        mark_explanations.push "Коэфициент cмен мест работы равен #{job_changing_coeficient}"
        calculating += "*#{job_changing_coeficient}"
      end
    end
    #End of fourth step mark

    #Fifth step mark
    if bankCredit[:customer_additional_employment_type].to_i != 10 && bankCredit[:customer_additional_employment_type].to_i != 4
      case bankCredit[:customer_activity_status].to_i
        when 38, 15, 17, 34, 35
          mark *= 1.2
          mark_explanations.push "Коэфициент сферы доп. деятельности равен 1.2"
          calculating += "*1.2"
        else
          mark *= 0.95
          mark_explanations.push "Коэфициент сферы доп. деятельности равен 0.95"
          calculating += "*0.95"
      end

      case bankCredit[:customer_additional_job_category].to_i
        when 4, 5, 8
          mark *= 1.2
          mark_explanations.push "Коэфициент занимаемой доп. должности равен 1.2"
          calculating += "*1.2"
        when 9
          percent = bankCredit[:customer_additional_owners_percent].to_f
          mark *= 1.0 + percent / 10.0
          mark_explanations.push "Коэфициент занимаемой доп. должности владельца предприятия равен #{1.0 + percent / 10.0}"
          calculating += "*#{1.0 + percent / 10.0}"
        else
          mark *= 1.01
          mark_explanations.push "Коэфициент занимаемой доп. должности равен 1.01"
          calculating += "*1.01"
      end
    end
    #End of fifth step mark

    #Sixth step validation
    if bankCredit[:customer_family_status] == 3 || bankCredit[:customer_family_status] == 4
      case bankCredit[:partner_education].to_i
        when 6
          mark *= 1.02
          mark_explanations.push "Коэфициент образования партнёра равен 1.02"
          calculating += "*1.02"
        when 7, 8
          mark *= 1.04
          mark_explanations.push "Коэфициент образования партнёра равен 1.04"
          calculating += "*1.04"
        else
          mark *= 0.98
          mark_explanations.push "Коэфициент образования партнёра равен 0.98"
          calculating += "*0.98"
      end
    end
    #End of sixth step mark

    #Ninth step mark
    incomingsAdditional = (bankCredit[:last_incomings].to_f + bankCredit[:family_incomings].to_f) / bankCredit[:last_outcomings].to_f
    incomingsAdditional = incomingsAdditional > 1.0 ? incomingsAdditional / 100 : incomingsAdditional / -100
    mark += incomingsAdditional
    mark_explanations.push "Коэфициент среднего достатка равен #{incomingsAdditional}"
    calculating += "+#{incomingsAdditional})"
    #End of ninth step mark

    #Tenth step mark
    if bankCredit[:another_contracts].to_i == 1
      mark *= 0.7
      mark_explanations.push "Коэфициент наличия обязательст перед другими банками равен 0.7"
      calculating += "*0.7"
    end
    if bankCredit[:unfinushed_contracts].to_i == 1
      mark *= 0.7
      mark_explanations.push "Коэфициент наличия невыполненныех контрактов равен 0.7"
      calculating += "*0.7"
    end
    if bankCredit[:mental_desease].to_i == 1
      mark *= 0.7
      mark_explanations.push "Коэфициент наличия психических расстройств равен 0.7"
      calculating += "*0.7"
    end
    if bankCredit[:guilty_contracts].to_i == 1
      mark *= 0.3
      mark_explanations.push "Коэфициент участия в качестве обвиняемого равен 0.3"
      calculating += "*0.3"
    end
    if bankCredit[:is_punished].to_i == 1
      mark *= 0.1
      mark_explanations.push "Коэфициент приговора суда равен 0.1"
      calculating += "*0.1"
    end
    if bankCredit[:partner_unfinushed_contracts].to_i == 1
      mark *= 0.8
      mark_explanations.push "Коэфициент незавершённых контрактов супруга равен 0.8"
      calculating += "*0.8"
    end
    if bankCredit[:partner_mental_desease].to_i == 1
      mark *= 0.8
      mark_explanations.push "Коэфициент психических расстройств супруга равен 0.8"
      calculating += "*0.8"
    end
    if bankCredit[:partner_guilty_contracts].to_i == 1
      mark *= 0.7
      mark_explanations.push "Коэфициент участия супруга в качестве обвиняемого равен 0.7"
      calculating += "*0.7"

    end
    if bankCredit[:partner_is_punished].to_i == 1
      mark *= 0.6
      mark_explanations.push "Коэфициент приговора суда над супругом равен 0.6"
      calculating += "*0.6"
    end
    #End of tenth step mark

    #Eleventh step mark
    if bankCredit[:rude_credits].to_i == 1
      mark *= 1.1
      mark_explanations.push "Коэфициент опыта кредитования в нашем банке равен 1.1"
      calculating += "*1.1"
    end

    if bankCredit[:another_credits].to_i == 1.01
      mark *= 1.01
      mark_explanations.push "Коэфициент опыта кредитования в других банках равен 1.01"
      calculating += "*1.01"
    end

    if bankCredit[:currentCreditsCount].to_i > 0
      mark *= 1.0 - bankCredit[:currentCreditsCount].to_i / 10.0
      mark_explanations.push "Коэфициент колличества действующих кредитов равен #{1.0 - bankCredit[:currentCreditsCount].to_i.to_f / 10.0}"
      calculating += "*#{1.0 - bankCredit[:currentCreditsCount].to_i.to_f / 10.0}"
    end

    if bankCredit[:currentCreditsSum].to_i > 0
      necessaryMark *= 1.0 + bankCredit[:currentCreditsSum].to_i / 1000.0
      mark_explanations.push "Необходимая оценка возрасла на #{1.0 + bankCredit[:currentCreditsSum].to_i / 1000.0}"
    end

    if bankCredit[:credit_violation].to_i == 1
      mark *= 0.7
      mark_explanations.push "Коэфициент нарушения сроков кредита равен 0.7"
      calculating += "*0.7"
    end

    if bankCredit[:procents_penaltyes].to_i == 1
      mark *= 0.85
      mark_explanations.push "Коэфициент нарушения процентов равен 0.85"
      calculating += "*0.85"
    end

    if bankCredit[:another_banks_credits].to_i == 1
      mark *= 0.78
      mark_explanations.push "Коэфициент поручительства равен 0.78"
      calculating += "*0.78"

    end

    if bankCredit[:guarantee].to_i == 1
      mark *= 0.64
      mark_explanations.push "Коэфициент исполнения обязательств должника равен 0.64"
      calculating += "*0.64"
    end

    if bankCredit[:installments].to_i == 1
      mark *= 0.6
      mark_explanations.push "Коэфициент задолженности по товарам в рассрочку равен 0.6"
      calculating += "*0.6"
    end
    #End of eleventh step mark

    if collateral_employee >= creditSum
      collateralEmployed = true
      calculatedMark = "#{collateral_employee}>#{creditSum}"
    end

    return mark, necessaryMark, mark_explanations, calculating, collateralEmployed, calculatedMark
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

    #Ninth step validation
    validation_errors.push "Укажите среднемесячные доходы за последние 6 месяцев на 9ом шаге." if bankCredit[:last_incomings].to_i < 0
    validation_errors.push "Укажите среднемесячные расходы за последние 6 месяцев на 9ом шаге." if bankCredit[:last_outcomings].to_i < 0
    validation_errors.push "Укажите среднемесячные доход семьи за последние 6 месяцев на 9ом шаге." if bankCredit[:family_incomings].to_i < 0
    #End of ninth step validation

    #Tenth step validation
    validation_errors.push "Укажите наличие ограничений со стороны других банков 10ом шаге." if bankCredit[:another_contracts].to_i < 1
    validation_errors.push "Укажите наличие невыполненных судебных решений 10ом шаге." if bankCredit[:unfinushed_contracts].to_i < 1
    validation_errors.push "Укажите наличие учёта у психиатора 10ом шаге." if bankCredit[:mental_desease].to_i < 1
    validation_errors.push "Укажите наличие судебного процесса 10ом шаге." if bankCredit[:guilty_contracts].to_i < 1
    validation_errors.push "Укажите наличие приговора 10ом шаге." if bankCredit[:is_punished].to_i < 1
    validation_errors.push "Укажите невыполненных судебных решений супругом 10ом шаге." if bankCredit[:partner_unfinushed_contracts].to_i < 1
    validation_errors.push "Укажите наличие учёта супругом у психиатора 10ом шаге." if bankCredit[:partner_mental_desease].to_i < 1
    validation_errors.push "Укажите наличие судебного процесса у супруга 10ом шаге." if bankCredit[:partner_guilty_contracts].to_i < 1
    validation_errors.push "Укажите приговора у супруга 10ом шаге." if bankCredit[:partner_is_punished].to_i < 1
    #End of tenth step validation

    #Eleventh step validation
    #End of eleventh step validation

    validation_errors == [] ? nil : validation_errors
  end
end
