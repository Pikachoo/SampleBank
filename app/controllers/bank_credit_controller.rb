require 'securerandom'
class BankCreditController < ApplicationController

  def new
    @credit_warrency_types = CreditWarrantyType.all
    @credit_payment_types = CreditPaymentType.all
    @credits = Credit.all
    @client_job_types = ClientJobType.all
    @client_family_status = ClientFamilyStatus.all
    @client_eduction = ClientEducation.all
    @bank_credit_inputs =  {credit_type: 0,
                            credit_type_another_car: '',
                            credit_type_another_card: '',
                            another_home_credit_type: '',
                            issuance_method: 0,
                            granted_procedure: 0,
                            issuance_score: '',
                            affirmation_of_commitments: 0,
                            collateral_employee: 0,
                            collateral_customer: 0,
                            score_id: '',
                            score_existance: 0,
                            credit_sum: 0,
                            credit_term: 0,
                            credit_limit_term: 0,
                            make_insurance: 0,
                            repayment_method: 0}
    @bank_credit_inputs = flash[:inputs_params] if flash[:inputs_params] != nil
  end

  def create
    validation_errors = validate
    return redirect_to :back, flash: { validation_errors: validate, inputs_params: params[:bank_credit] } if validation_errors != nil

    application_id = SecureRandom.uuid
    bank_credit_params = params[:bank_credit]
    bank_credit_params.to_a.to_h.each do |key, value|
      credit_application_item = CreditApplication.new
      credit_application_item.param_names = key
      credit_application_item.param_values = value
      credit_application_item.application_id = application_id.to_s
      credit_application_item.save
    end

    @mark, @necessary_mark, @mark_explanations, @calculating, @is_collateral_employed, @credit_sum = calculate_mark
    # if @mark > @necessary_mark
    #   client = save_client
    #   puts json: client
    #   save_credit(client)
    # end
  end

  def save_client
    client = Client.new

    client.name = params[:bank_credit][:customer_firstname]
    client.surname = params[:bank_credit][:customer_lastname]
    client.patronymic = params[:bank_credit][:customer_patronymic]
    client.birth_date = params[:bank_credit][:customer_birthdate]
    client.passport_identificational_number = params[:bank_credit][:customer_id]
    client.sex = 'M'
    client.family_status_id = params[:bank_credit][:customer_family_status]
    client.phone_home = params[:bank_credit][:customer_actual_phone]
    client.phone_mobile= params[:bank_credit][:customer_mobile_phone]
    client.phone_work= params[:bank_credit][:customer_work_phone]
    client.email = 'sdaf@gmail.com'
    client.passport_series = params[:bank_credit][:customer_document_series]
    client.passport_number = params[:bank_credit][:customer_document_number]
    client.passport_begin_date = params[:bank_credit][:customer_document_given_date]
    client.passport_end_date = params[:bank_credit][:customer_document_end_date]
    client.address_living = params[:bank_credit][:customer_actual_living_place]
    client.address_registration = params[:bank_credit][:customer_registration_address]
    client.education_id = params[:bank_credit][:customer_education]
    client.job_type_id = params[:bank_credit][:customer_activity_status]
    client.salary = params[:bank_credit][:last_incomings]

    client_search = Client.find_by_passport_identificational_number(client.passport_identificational_number)

    if client_search.nil?
      client.save
      client
    else
      client_search.surname = client.surname
      client_search.sex = client.sex
      client_search.family_status_id = client.family_status_id
      client_search.phone_home = client.phone_home
      client_search.phone_mobile = client.phone_mobile
      client_search.phone_work = client.phone_work
      client_search.email = client.email
      client_search.passport_series = client.passport_series
      client_search.passport_number = client.passport_number
      client_search.passport_begin_date = client.passport_begin_date
      client_search.passport_end_date = client.passport_end_date
      client_search.address_living = client.address_living
      client_search.address_registration = client.address_registration
      client_search.education_id = client.education_id
      client_search.job_type_id = client.job_type_id
      client_search.salary = client.salary
      client_search.save
      client_search
    end
  end
  def save_credit(client)
    client_credit = ClientCredit.new
    client_credit.client_id = client.id
    client_credit.credit_id = params[:bank_credit][:credit_type]
    client_credit.begin_date = Date.today
    client_credit.sum = params[:bank_credit][:credit_sum]
    client_credit.term = params[:bank_credit][:credit_term]
    client_credit.limit_term = params[:bank_credit][:credit_limit_term]
    client_credit.payment_id = params[:bank_credit][:issuance_method]
    client_credit.granting_id = params[:bank_credit][:granted_procedure]
    if params[:bank_credit][:repayment_method] == 1
      client_credit.repayment_method = 'Стандартный'
    else
      client_credit.repayment_method = 'Равными долями'
    end
    client_credit_search = ClientCredit.where(client_id: client_credit.client_id, credit_id: client_credit.credit_id, begin_date: client_credit.begin_date)
    if client_credit_search.empty?
      client_credit.save
    end
    puts json: client_credit_search
  end

  def calculate_mark
    mark = 1.0
    necessary_mark = 0
    mark_explanations = []
    calculating = ''
    bank_credit = params[:bank_credit]
    collateral_employee = 0
    collateral_employed = false
    calculated_mark = '('

    #First step mark
    case bank_credit[:credit_type].to_i
      when 3, 5, 9
        mark *= 1.2
        mark_explanations.push 'Коэфициент предоставленного кредита составляет 1.2'
        calculating += '(1.2'
      when 2
        mark *= 1.12
        mark_explanations.push 'Коэфициент предоставленного кредита на приобретения жилья составляет 1.12'
        calculating += '(1.12'
      else
        mark *= 0.95
        mark_explanations.push 'Коэфициент предоставленного кредита составляет 0.95'
        calculating += '(0.95'
    end

    case bank_credit[:granted_procedure].to_i
      when 1
        mark += 0.05
        mark_explanations.push 'Выбран единовременный порядок предоставления, добавлен коэфициент равный 0.05'
        calculating += '+0.05)'
      when 2
        mark += 0.07
        mark_explanations.push 'Выбрана невозобновляемая кредитная линия, добавлен коэфициент равный 0.07'
        calculating += '+0.07)'
      when 3
        mark += 0.1
        mark_explanations.push 'Выбран невозобновляемая кредитная линия с использованием банковской карты, добавлен коэфициент равный 0.1'
        calculating += '+0.1)'
    end

    case bank_credit[:issuance_method].to_i
      when 1, 3, 4
        mark *= 1.1
        mark_explanations.push 'Коэфициент способа выдачи равнен 1.1'
        calculating += '*1.1'
      else
        mark *= 0.98
        mark_explanations.push 'Коэфициент способа выдачи равнен 0.98'
        calculating += '*0.98'
    end

    case bank_credit[:affirmation_of_commitments].to_i
      when 10, 11, 12
        mark *= 1.1
        mark_explanations.push 'Коэфициент обеспечения кредитных обязательств равнен 1.1'
        calculating += '*1.1'
      when 7, 6, 4, 9
        mark *= 1.05
        mark_explanations.push 'Коэфициент обеспечения кредитных обязательств равнен 1.05'
        calculating += '*1.05'
      else
        mark *= 0.9
        mark_explanations.push 'Коэфициент обеспечения кредитных обязательств равнен 0.9'
        calculating += '*0.9'
    end

    if bank_credit[:account_id].to_i == 1
      mark *= 1.05
      mark_explanations.push ['Ввиду наличия в нашем банке счёта, добавночный коэфициент будет равен 1.05']
      calculating += '*1.05'
    end

    collateral_employee = bank_credit[:collateral_employee].to_i if bank_credit[:collateral_employee] != 0
    #End of first step mark

    #Second step mark
    credit_sum = bank_credit[:credit_sum].to_f
    necessary_mark = credit_sum / 2000000000.0

    mark_explanations.push "Необходимая оценка равна #{necessary_mark}"

    mark *= bank_credit[:credit_term].to_f / 12.0
    mark_explanations.push "Добавночный коэфициент для срока кредита будет равен #{(bank_credit[:credit_term].to_f / 12.0).round(2)}"
    calculating += "*#{(bank_credit[:credit_term].to_f / 12.0).round(2)}"

    case bank_credit[:make_insurance].to_i
      when 1
        mark *= 1.1
        mark_explanations.push 'Добавночный коэфициент в связи со страховкой равен 1.1'
        calculating += '*1.1'
      when 2
        mark *= 0.7
        mark_explanations.push 'Добавночный коэфициент в виду отсутствия страховки равен 0.7'
        calculating += '*0.7'
    end

    if bank_credit[:repayment_method].to_i == 2
      mark *= 1.05
      mark_explanations.push 'Добавночный коэфициент погашения равными долями равен 1.05'
      calculating += '*1.05'
    end
    #End of second step mark

    #Third step mark
    case bank_credit[:customer_living_conditions].to_i
      when 1
        mark *= 1.15
        mark_explanations.push 'В связи с наличием собственной квартиры коэфициент равен 1.15'
        calculating += '*1.15'
      when 2
        mark *= 0.95
        mark_explanations.push 'Коэфициент съёмной квартиры равен 0.9'
        calculating += '*0.9'
      else
        mark *= 0.7
        mark_explanations.push 'Коэфициент жилищных условий 0.7'
        calculating += '*0.7'
    end

    case bank_credit[:customer_education].to_i
      when 6
        mark *= 1.02
        mark_explanations.push 'Коэфициент образования равен 1.02'
        calculating += '*1.02'
      when 7, 8
        mark *= 1.04
        mark_explanations.push 'Коэфициент образования равен 1.04'
        calculating += '*1.04'
      else
        mark *= 0.98
        mark_explanations.push 'Коэфициент образования равен 0.98'
        calculating += '*0.98'
    end

    case bank_credit[:customer_military_conditions].to_i
      when 1, 2
        mark_explanations.push 'Коэфициент отношения к воинской службе равен 1'
        calculating += '*1'
      else
        mark *= 0.93
        mark_explanations.push 'Коэфициент отношения к воинской службе равен 0.93'
        calculating += '*0.93'
    end

    if bank_credit[:customer_age].to_i < 18
      mark *= -1
      mark_explanations.push 'Ввиду несовершеннолетия клиента мы не можем выдать ему кредит.'
      calculating += '*-1'
    end
    #End of third step mark

    #Fourth step mark
    case bank_credit[:customer_employment_type].to_i
      when 10
        mark *= 0.01
        mark_explanations.push 'Ввиду Отсутствия работы коэфициент кредита равен 0.1'
        calculating += '*0.1'
      when 9
        mark *= 0.2
        mark_explanations.push 'Ввиду частной практики коэфициент кредита равен 0.2'
        calculating += '*0.2'
      when 4
        mark *= 0.05
        mark_explanations.push 'Ввиду того что клиент пенсионер коэфициент кредита равен 0.4'
        calculating += '*0.4'
      when 3, 5
        mark *= 1.1
        mark_explanations.push 'Коэфициент кредита по работе равен 1.1'
        calculating += '*1.1'
      else
        mark *= 0.91
        mark_explanations.push 'Коэфициент кредита по работе равен 0.91'
        calculating += '*0.91'
    end

    if bank_credit[:customer_employment_type].to_i != 10 && bank_credit[:customer_employment_type].to_i != 4
      case bank_credit[:customer_activity_status].to_i
        when 38, 15, 17, 34, 35
          mark *= 1.2
          mark_explanations.push 'Коэфициент сферы деятельности равен 1.2'
          calculating += '*1.2'
        else
          mark *= 0.95
          mark_explanations.push 'Коэфициент сферы деятельности равен 0.95'
          calculating += '*0.95'
      end

      case bank_credit[:customer_job_category].to_i
        when 4, 5, 8
          mark *= 1.2
          mark_explanations.push 'Коэфициент занимаемой должности равен 1.2'
          calculating += '*1.2'
        when 9
          percent = bank_credit[:customer_owners_percent].to_f
          mark *= 1.0 + percent / 10.0
          mark_explanations.push "Коэфициент занимаемой должности владельца предприятия равен #{1.0 + percent / 10.0}"
          calculating += "*#{1.0 + percent / 10.0}"
        else
          mark *= 0.95
          mark_explanations.push 'Коэфициент занимаемой должности равен 0.95'
          calculating += '*0.95'
      end

      job_changing_coeficient = 1.0 - bank_credit[:customer_job_changing_value].to_i / 30.0
      if job_changing_coeficient != 0
        mark *= job_changing_coeficient
        mark_explanations.push "Коэфициент cмен мест работы равен #{job_changing_coeficient}"
        calculating += "*#{job_changing_coeficient}"
      end
    end
    #End of fourth step mark

    #Fifth step mark
    if bank_credit[:customer_additional_employment_type].to_i != 10 && bank_credit[:customer_additional_employment_type].to_i != 4
      case bank_credit[:customer_activity_status].to_i
        when 38, 15, 17, 34, 35
          mark *= 1.2
          mark_explanations.push 'Коэфициент сферы доп. деятельности равен 1.2'
          calculating += '*1.2'
        else
          mark *= 0.95
          mark_explanations.push 'Коэфициент сферы доп. деятельности равен 0.95'
          calculating += '*0.95'
      end

      case bank_credit[:customer_additional_job_category].to_i
        when 4, 5, 8
          mark *= 1.2
          mark_explanations.push 'Коэфициент занимаемой доп. должности равен 1.2'
          calculating += '*1.2'
        when 9
          percent = bank_credit[:customer_additional_owners_percent].to_f
          mark *= 1.0 + percent / 10.0
          mark_explanations.push "Коэфициент занимаемой доп. должности владельца предприятия равен #{1.0 + percent / 10.0}"
          calculating += "*#{1.0 + percent / 10.0}"
        else
          mark *= 1.01
          mark_explanations.push 'Коэфициент занимаемой доп. должности равен 1.01'
          calculating += '*1.01'
      end
    end
    #End of fifth step mark

    #Sixth step validation
    if bank_credit[:customer_family_status] == 3 || bank_credit[:customer_family_status] == 4
      case bank_credit[:partner_education].to_i
        when 6
          mark *= 1.02
          mark_explanations.push 'Коэфициент образования партнёра равен 1.02'
          calculating += '*1.02'
        when 7, 8
          mark *= 1.04
          mark_explanations.push 'Коэфициент образования партнёра равен 1.04'
          calculating += '*1.04'
        else
          mark *= 0.98
          mark_explanations.push 'Коэфициент образования партнёра равен 0.98'
          calculating += '*0.98'
      end
    end
    #End of sixth step mark

    #Ninth step mark
    incomings_additional = (bank_credit[:last_incomings].to_f + bank_credit[:family_incomings].to_f) / bank_credit[:last_outcomings].to_f
    incomings_additional = incomings_additional > 1.0 ? incomings_additional / 100 : incomings_additional / -100
    mark += incomings_additional
    mark_explanations.push "Коэфициент среднего достатка равен #{incomings_additional}"
    calculating += "+#{incomings_additional})"
    #End of ninth step mark


    #Tenth step mark
    if bank_credit[:another_contracts].to_i == 1
      mark *= 0.7
      mark_explanations.push 'Коэфициент наличия обязательст перед другими банками равен 0.7'
      calculating += '*0.7'
    end
    if bank_credit[:unfinushed_contracts].to_i == 1
      mark *= 0.7
      mark_explanations.push 'Коэфициент наличия невыполненныех контрактов равен 0.7'
      calculating += '*0.7'
    end
    if bank_credit[:mental_desease].to_i == 1
      mark *= 0.7
      mark_explanations.push 'Коэфициент наличия психических расстройств равен 0.7'
      calculating += '*0.7'
    end
    if bank_credit[:guilty_contracts].to_i == 1
      mark *= 0.3
      mark_explanations.push 'Коэфициент участия в качестве обвиняемого равен 0.3'
      calculating += '*0.3'
    end
    if bank_credit[:is_punished].to_i == 1
      mark *= 0.1
      mark_explanations.push 'Коэфициент приговора суда равен 0.1'
      calculating += '*0.1'
    end
    if bank_credit[:partner_unfinushed_contracts].to_i == 1
      mark *= 0.8
      mark_explanations.push 'Коэфициент незавершённых контрактов супруга равен 0.8'
      calculating += '*0.8'
    end
    if bank_credit[:partner_mental_desease].to_i == 1
      mark *= 0.8
      mark_explanations.push 'Коэфициент психических расстройств супруга равен 0.8'
      calculating += '*0.8'
    end
    if bank_credit[:partner_guilty_contracts].to_i == 1
      mark *= 0.7
      mark_explanations.push 'Коэфициент участия супруга в качестве обвиняемого равен 0.7'
      calculating += '*0.7'

    end
    if bank_credit[:partner_is_punished].to_i == 1
      mark *= 0.6
      mark_explanations.push 'Коэфициент приговора суда над супругом равен 0.6'
      calculating += '*0.6'
    end
    #End of tenth step mark

    #Eleventh step mark
    if bank_credit[:rude_credits].to_i == 1
      mark *= 1.1
      mark_explanations.push 'Коэфициент опыта кредитования в нашем банке равен 1.1'
      calculating += '*1.1'
    end

    if bank_credit[:another_credits].to_i == 1.01
      mark *= 1.01
      mark_explanations.push 'Коэфициент опыта кредитования в других банках равен 1.01'
      calculating += '*1.01'
    end

    if bank_credit[:currentCreditsCount].to_i > 0
      mark *= 1.0 - bank_credit[:currentCreditsCount].to_i / 10.0
      mark_explanations.push "Коэфициент колличества действующих кредитов равен #{1.0 - bank_credit[:currentCreditsCount].to_i.to_f / 10.0}"
      calculating += "*#{1.0 - bank_credit[:currentCreditsCount].to_i.to_f / 10.0}"
    end

    if bank_credit[:currentCreditsSum].to_i > 0
      necessary_mark *= 1.0 + bank_credit[:currentCreditsSum].to_i / 1000.0
      mark_explanations.push "Необходимая оценка возрасла на #{1.0 + bank_credit[:currentCreditsSum].to_i / 1000.0}"
    end

    if bank_credit[:credit_violation].to_i == 1

      mark *= 0.7
      mark_explanations.push 'Коэфициент нарушения сроков кредита равен 0.7'
      calculating += '*0.7'
    end

    if bank_credit[:procents_penaltyes].to_i == 1
      mark *= 0.85
      mark_explanations.push 'Коэфициент нарушения процентов равен 0.85'
      calculating += '*0.85'
    end

    if bank_credit[:another_banks_credits].to_i == 1
      mark *= 0.78
      mark_explanations.push 'Коэфициент поручительства равен 0.78'
      calculating += '*0.78'

    end

    if bank_credit[:guarantee].to_i == 1
      mark *= 0.64
      mark_explanations.push 'Коэфициент исполнения обязательств должника равен 0.64'
      calculating += '*0.64'
    end

    if bank_credit[:installments].to_i == 1
      mark *= 0.6
      mark_explanations.push 'Коэфициент задолженности по товарам в рассрочку равен 0.6'
      calculating += '*0.6'
    end
    #End of eleventh step mark

    if collateral_employee >= credit_sum
      collateral_employed = true
      calculated_mark = "#{collateral_employee}>#{credit_sum}"
    end

    return mark, necessary_mark, mark_explanations, calculating, collateral_employed, calculated_mark
  end

  def online_credit_params
    #params.require(:bank_credit).permit(:credit_type, :credit_type_another_car)
  end

  def validate
    validation_errors = []
    bank_credit = params[:bank_credit]
    #First step validation
    validation_errors.push 'Выберите тип кредита на 1ом шаге.' if bank_credit[:credit_type].to_i < 1 || bank_credit[:credit_type].to_i > 10
    # validation_errors.push 'Укажите вид финансирования недвижимости на 1ом шаге.' if bank_credit[:credit_type].to_i == 4 && bank_credit[:another_home_credit_type] == ''
    # validation_errors.push 'Укажите вид автокредита на 1ом шаге.' if bank_credit[:credit_type].to_i == 6 && bank_credit[:credit_type_another_car] == ''
    # validation_errors.push 'Укажите вид кредитных карт на 1ом шаге.' if bank_credit[:credit_type].to_i == 8 && bank_credit[:credit_type_another_card] == ''
    validation_errors.push 'Выберите порядок предоставления на 1ом шаге.' if bank_credit[:granted_procedure].to_i < 1 || bank_credit[:granted_procedure].to_i > 3
    # validation_errors.push 'Выберите порядок обеспечения на 1ом шаге.' if bank_credit[:affirmation_of_commitments].to_i < 1 || bank_credit[:affirmation_of_commitments].to_i > 13
    validation_errors.push 'Выберите способ выдачи на 1ом шаге.' if bank_credit[:issuance_method].to_i < 1 || bank_credit[:granted_procedure].to_i > 5
    validation_errors.push 'Укажите наличие счёта в нашем банке на 1ом шаге.' if bank_credit[:score_existance].to_i < 1 || bank_credit[:score_existance].to_i > 2
    validation_errors.push 'Укажите номер счёта в нашем банке на 1ом шаге.' if bank_credit[:score_existance].to_i == 1 && bank_credit[:account_id] == ''
    validation_errors.push 'Укажите номер счёта получателя на 1ом шаге.' if bank_credit[:issuance_method].to_i == 5 && bank_credit[:issuance_score] == ''
    validation_errors.push 'Введите достоверную оценку залога клиентом на 1ом шаге.' if bank_credit[:collateral_customer] != '' && bank_credit[:collateral_customer].to_i < 0
    validation_errors.push 'Введите достоверную оценку залога служащим на 1ом шаге.' if bank_credit[:collateral_employee] != '' && bank_credit[:collateral_employee].to_i < 0
    #End of first step validation

    #Second step validation
    validation_errors.push 'Укажите сумму кредита на 2ом шаге.' if bank_credit[:credit_sum].to_i < 1
    validation_errors.push 'Укажите срок кредита на 2ом шаге.' if bank_credit[:credit_term].to_i < 1
    validation_errors.push 'Укажите срок освоения кредита на 2ом шаге.' if bank_credit[:credit_limit_term].to_i < 1
    # validation_errors.push 'Укажите ответ на совокупный кредит на 2ом шаге.' if bank_credit[:total_income].to_i < 1 || bank_credit[:total_income].to_i > 2
    validation_errors.push 'Укажите будет ли клиент страховаться на 2ом шаге.' if bank_credit[:make_insurance].to_i < 1 || bank_credit[:total_income].to_i > 2
    validation_errors.push 'Укажите вид выплаты кредита на 2ом шаге.' if bank_credit[:repayment_method].to_i < 1 || bank_credit[:total_income].to_i > 2
    #End of second step validation

    #Third step validation
    validation_errors.push 'Укажите имя клиента на 3ем шаге.' if bank_credit[:customer_firstname] == ''
    validation_errors.push 'Укажите фамилию клиента на 3ем шаге.' if bank_credit[:customer_lastname] == ''
    validation_errors.push 'Укажите отчество клиента на 3ем шаге.' if bank_credit[:customer_patronymic] == ''
    validation_errors.push 'Укажите день рождения клиента на 3ем шаге.' if bank_credit[:customer_birthdate] == ''
    validation_errors.push 'Укажите идентификационный номер клиента на 3ем шаге.' if bank_credit[:customer_id] == ''
    validation_errors.push 'Укажите возраст клиента на 3ем шаге.' if bank_credit[:customer_age] == '' || bank_credit[:customer_age].to_i < 1
    validation_errors.push 'Укажите гражданство клиента на 3ем шаге.' if bank_credit[:customer_country] == ''
    validation_errors.push 'Укажите место рождения клиента на 3ем шаге.' if bank_credit[:customer_birthplace] == ''
    validation_errors.push 'Укажите семейное положение клиента на 3ем шаге.' if bank_credit[:customer_family_status].to_i < 1 || bank_credit[:customer_family_status].to_i > 5
    validation_errors.push 'Укажите жилищные условия клиента на 3ем шаге.' if bank_credit[:customer_living_conditions].to_i < 1 || bank_credit[:customer_living_conditions].to_i > 8
    validation_errors.push 'Укажите тип жилищных условий клиента на 3ем шаге.' if bank_credit[:customer_living_conditions].to_i == 8 && bank_credit[:customer_another_living_conditions] == ''
    validation_errors.push 'Укажите образование клиента на 3ем шаге.' if bank_credit[:customer_education].to_i < 1 || bank_credit[:customer_education].to_i > 8
    validation_errors.push 'Укажите отношение клиента к воинской службе на 3ем шаге.' if bank_credit[:customer_military_conditions].to_i < 1 || bank_credit[:customer_military_conditions].to_i > 4
    validation_errors.push 'Укажите дату отсрочки клиента от воинской службы на 3ем шаге.' if bank_credit[:customer_military_conditions].to_i == 3 && bank_credit[:customer_reprieve_end_date] == ''
    validation_errors.push 'Укажите информацию об имени клиента на 3ем шаге.' if bank_credit[:customer_name_info].to_i < 1 || bank_credit[:customer_name_info].to_i > 2
    validation_errors.push 'Укажите причину смены имени клиентом на 3ем шаге.' if bank_credit[:customer_name_info].to_i == 1 && bank_credit[:customer_changing_reason] == ''
    validation_errors.push 'Укажите наименование документа клиента на 3ем шаге.' if bank_credit[:customer_document_type] == ''
    validation_errors.push 'Укажите серию документа клиента на 3ем шаге.' if bank_credit[:customer_document_series] == ''
    validation_errors.push 'Укажите номер документа клиента на 3ем шаге.' if bank_credit[:customer_document_number] == ''
    validation_errors.push 'Укажите дату выдачи документа клиента на 3ем шаге.' if bank_credit[:customer_document_given_date] == ''
    validation_errors.push 'Укажите дату окончания документа клиента на 3ем шаге.' if bank_credit[:customer_document_end_date] == ''
    validation_errors.push 'Укажите адрес регистрации по месту жительства клиента на 3ем шаге.' if bank_credit[:customer_registration_address] == ''
    validation_errors.push 'Укажите адрес по месту пребывания клиента на 3ем шаге.' if bank_credit[:customer_registration_place] == ''
    validation_errors.push 'Укажите адрес фактического места проживания клиента на 3ем шаге.' if bank_credit[:customer_actual_living_place] == ''
    validation_errors.push 'Укажите срок проживания по месту фактического проживания клиента на 3ем шаге.' if bank_credit[:customer_living_age].to_i < 1
    #End of third step validation

    #Fourth step validation
    validation_errors.push 'Укажите тип работы клиента на 4ом шаге.' if bank_credit[:customer_employment_type].to_i < 1 || bank_credit[:customer_employment_type].to_i > 11
    if bank_credit[:customer_employment_type].to_i != 10
      validation_errors.push 'Укажите место практики клиента на 4ом шаге.' if bank_credit[:customer_employment_type] == '9' && bank_credit[:customer_practical_employment] == ''
      validation_errors.push 'Укажите тип занятости клиента на 4ом шаге.' if bank_credit[:customer_employment_type] == '11' && bank_credit[:customer_another_employment] == ''
      validation_errors.push 'Укажите начало работы клиента на 4ом шаге.' if bank_credit[:customer_start_job_date] == ''
      validation_errors.push 'Укажите конец контракта клиента на 4ом шаге.' if bank_credit[:customer_end_job_date] == ''
      validation_errors.push 'Укажите наименование организации клиента на 4ом шаге.' if bank_credit[:customer_organization_name] == ''
      validation_errors.push 'Укажите должность работы клиента на 4ом шаге.' if bank_credit[:customer_job_name] == ''
      validation_errors.push 'Укажите адрес работы клиента на 4ом шаге.' if bank_credit[:customer_organization_address] == ''
      validation_errors.push 'Укажите сферу деятельности клиента на 4ом шаге.' if bank_credit[:customer_activity_status].to_i < 1 || bank_credit[:customer_activity_status].to_i > 38
      validation_errors.push 'Укажите численность рабочих на 4ом шаге.' if bank_credit[:customer_employers_count].to_i < 1 || bank_credit[:customer_employers_count].to_i > 6
      validation_errors.push 'Укажите стаж работы на 4ом шаге.' if bank_credit[:customer_experience_in_organization].to_i < 1 || bank_credit[:customer_experience_in_organization].to_i > 7
      validation_errors.push 'Укажите категорию занимаемой должности на 4ом шаге.' if bank_credit[:customer_job_category].to_i < 1 || bank_credit[:customer_job_category].to_i > 10
      validation_errors.push 'Укажите процент от доходов предприятия на 4ом шаге.' if bank_credit[:customer_job_category].to_i == 9 && (bank_credit[:customer_owners_percent].to_f <= 0.0 || bank_credit[:customer_owners_percent].to_f > 100)
    end
    #End of fourth step validation

    #Fifth step validation
    validation_errors.push 'Укажите тип работы клиента на 5ом шаге.' if bank_credit[:customer_additional_employment_type].to_i < 1 || bank_credit[:customer_additional_employment_type].to_i > 11
    if bank_credit[:customer_additional_employment_type].to_i != 10
      validation_errors.push 'Укажите место практики клиента на 5ом шаге.' if bank_credit[:customer_additional_employment_type] == '9' && bank_credit[:customer_additional_practical_employment] == ''
      validation_errors.push 'Укажите тип занятости клиента на 5ом шаге.' if bank_credit[:customer_additional_employment_type] == '11' && bank_credit[:customer_additional_another_employment] == ''
      validation_errors.push 'Укажите начало работы клиента на 5ом шаге.' if bank_credit[:customer_additional_start_job_date] == ''
      validation_errors.push 'Укажите конец контракта клиента на 5ом шаге.' if bank_credit[:customer_additional_end_job_date] == ''
      validation_errors.push 'Укажите наименование организации клиента на 5ом шаге.' if bank_credit[:customer_additional_organization_name] == ''
      validation_errors.push 'Укажите должность работы клиента на 5ом шаге.' if bank_credit[:customer_additional_job_name] == ''
      validation_errors.push 'Укажите адрес работы клиента на 5ом шаге.' if bank_credit[:customer_additional_organization_address] == ''
      validation_errors.push 'Укажите сферу деятельности клиента на 5ом шаге.' if bank_credit[:customer_additional_activity_status].to_i < 1 || bank_credit[:customer_additional_activity_status].to_i > 38
      validation_errors.push 'Укажите численность рабочих на 5ом шаге.' if bank_credit[:customer_additional_employers_count].to_i < 1 || bank_credit[:customer_additional_employers_count].to_i > 6
      validation_errors.push 'Укажите стаж работы на 5ом шаге.' if bank_credit[:customer_additional_experience_in_organization].to_i < 1 || bank_credit[:customer_additional_experience_in_organization].to_i > 7
      validation_errors.push 'Укажите категорию занимаемой должности на 5ом шаге.' if bank_credit[:customer_additional_job_category].to_i < 1 || bank_credit[:customer_additional_job_category].to_i > 10
      validation_errors.push 'Укажите процент от доходов предприятия на 5ом шаге.' if bank_credit[:customer_additional_job_category].to_i == 9 && (bank_credit[:customer_additional_owners_percent].to_f <= 0.0 || bank_credit[:customer_owners_percent].to_f > 100)
    end
    #End of fifth step validation

    #Sixth step validation (3 - 4)
    if bank_credit[:customer_family_status].to_i == 3 || bank_credit[:customer_family_status].to_i == 4
      validation_errors.push 'Укажите имя супруга клиента на 6ом шаге.' if bank_credit[:partner_firstname] == ''
      validation_errors.push 'Укажите фамилию супруга клиента на 6ом шаге.' if bank_credit[:partner_lastname] == ''
      validation_errors.push 'Укажите отчество супруга клиента на 6ом шаге.' if bank_credit[:partner_patronymic] == ''
      validation_errors.push 'Укажите день рождения супруга клиента на 6ом шаге.' if bank_credit[:partner_birthdate] == ''
      validation_errors.push 'Укажите идентификационный номер супруга клиента на 6ом шаге.' if bank_credit[:partner_id] == ''
      validation_errors.push 'Укажите возраст супруга клиента на 6ом шаге.' if bank_credit[:partner_age] == '' || bank_credit[:partner_age].to_i < 1
      validation_errors.push 'Укажите гражданство супруга клиента на 6ом шаге.' if bank_credit[:partner_country] == ''
      validation_errors.push 'Укажите место рождения супруга клиента на 6ом шаге.' if bank_credit[:partner_birthplace] == ''
      validation_errors.push 'Укажите семейное положение супруга клиента на 6ом шаге.' if bank_credit[:partner_family_status].to_i < 1 || bank_credit[:partner_family_status].to_i > 5
      validation_errors.push 'Укажите жилищные условия супруга клиента на 6ом шаге.' if bank_credit[:partner_living_conditions].to_i < 1 || bank_credit[:partner_living_conditions].to_i > 8
      validation_errors.push 'Укажите тип жилищных условий супруга клиента на 6ом шаге.' if bank_credit[:partner_living_conditions].to_i == 8 && bank_credit[:partner_another_living_conditions] == ''
      validation_errors.push 'Укажите образование супруга клиента на 6ом шаге.' if bank_credit[:partner_education].to_i < 1 || bank_credit[:partner_education].to_i > 8
      validation_errors.push 'Укажите отношение супруга клиента к воинской службе на 6ом шаге.' if bank_credit[:partner_military_conditions].to_i < 1 || bank_credit[:partner_military_conditions].to_i > 4
      validation_errors.push 'Укажите дату отсрочки супруга клиента от воинской службы на 6ом шаге.' if bank_credit[:partner_military_conditions].to_i == 3 && bank_credit[:partner_reprieve_end_date] == ''
      validation_errors.push 'Укажите информацию об имени супруга клиента на 6ом шаге.' if bank_credit[:partner_name_info].to_i < 1 || bank_credit[:partner_name_info].to_i > 2
      validation_errors.push 'Укажите причину смены имени супруга клиента на 6ом шаге.' if bank_credit[:partner_name_info].to_i == 1 && bank_credit[:partner_changing_reason] == ''
      validation_errors.push 'Укажите наименование документа супруга клиента на 6ом шаге.' if bank_credit[:partner_document_type] == ''
      validation_errors.push 'Укажите серию документа супруга клиента на 6ом шаге.' if bank_credit[:partner_document_series] == ''
      validation_errors.push 'Укажите номер документа супруга клиента на 6ом шаге.' if bank_credit[:partner_document_number] == ''
      validation_errors.push 'Укажите дату выдачи документа супруга клиента на 6ом шаге.' if bank_credit[:partner_document_given_date] == ''
      validation_errors.push 'Укажите дату окончания документа супруга клиента на 6ом шаге.' if bank_credit[:partner_document_end_date] == ''
      validation_errors.push 'Укажите адрес регистрации по месту жительства супруга клиента на 6ом шаге.' if bank_credit[:partner_registration_address] == ''
      validation_errors.push 'Укажите адрес по месту пребывания супруга клиента на 6ом шаге.' if bank_credit[:partner_registration_place] == ''
      validation_errors.push 'Укажите адрес фактического места проживания супруга клиента на 6ом шаге.' if bank_credit[:partner_actual_living_place] == ''
      validation_errors.push 'Укажите срок проживания по месту фактического проживания супруга клиента на 6ом шаге.' if bank_credit[:partner_living_age].to_i < 1
      validation_errors.push 'Укажите организации работы супруга клиента на 6ом шаге.' if bank_credit[:partner_organization_name] == ''
      validation_errors.push 'Укажите должность супруга клиента на 6ом шаге.' if bank_credit[:partner_job_name] == ''
      validation_errors.push 'Укажите адрес организации супруга клиента на 6ом шаге.' if bank_credit[:partner_organization_address] == ''
    end
    #End of sixth step validation

    #Ninth step validation
    validation_errors.push 'Укажите среднемесячные доходы за последние 6 месяцев на 9ом шаге.' if bank_credit[:last_incomings].to_i < 0
    validation_errors.push 'Укажите среднемесячные расходы за последние 6 месяцев на 9ом шаге.' if bank_credit[:last_outcomings].to_i < 0
    validation_errors.push 'Укажите среднемесячные доход семьи за последние 6 месяцев на 9ом шаге.' if bank_credit[:family_incomings].to_i < 0
    #End of ninth step validation

    #Tenth step validation
    validation_errors.push 'Укажите наличие ограничений со стороны других банков 10ом шаге.' if bank_credit[:another_contracts].to_i < 1
    validation_errors.push 'Укажите наличие невыполненных судебных решений 10ом шаге.' if bank_credit[:unfinushed_contracts].to_i < 1
    validation_errors.push 'Укажите наличие учёта у психиатора 10ом шаге.' if bank_credit[:mental_desease].to_i < 1
    validation_errors.push 'Укажите наличие судебного процесса 10ом шаге.' if bank_credit[:guilty_contracts].to_i < 1
    validation_errors.push 'Укажите наличие приговора 10ом шаге.' if bank_credit[:is_punished].to_i < 1
    validation_errors.push 'Укажите невыполненных судебных решений супругом 10ом шаге.' if bank_credit[:partner_unfinushed_contracts].to_i < 1
    validation_errors.push 'Укажите наличие учёта супругом у психиатора 10ом шаге.' if bank_credit[:partner_mental_desease].to_i < 1
    validation_errors.push 'Укажите наличие судебного процесса у супруга 10ом шаге.' if bank_credit[:partner_guilty_contracts].to_i < 1
    validation_errors.push 'Укажите приговора у супруга 10ом шаге.' if bank_credit[:partner_is_punished].to_i < 1
    #End of tenth step validation

    #Eleventh step validation
    #End of eleventh step validation

    validation_errors == [] ? nil : validation_errors
  end
end