class OnlineCreditController < ApplicationController

  def new
    client_job_types = ClientJobType.all
    credit_warranty_types = CreditWarrentyType.all
    currencies = Currency.all
    client_goals = ClientCreditGoal.all

    @online_credit_inputs = {credit_product_type: "0",
                             currency_type: "0",
                             sum_value: "0",
                             term_loan_product: "0",
                             provision_type: "0",
                             other_provision_type: "",
                             organization_name: "",
                             customers_address: "",
                             main_activity_type: "0",
                             alt_main_activity: "",
                             organization_experience: "",
                             customers_firstname: "",
                             customers_lastname: "",
                             customers_patronymic: "",
                             customers_phone: "",
                             customers_email: "",
                             salary: "0"}
    @online_credit_inputs = flash[:inputs_params] if flash[:inputs_params] != nil
    @online_credit_inputs[:client_job_types] = client_job_types
    @online_credit_inputs[:credit_warranty_types] = credit_warranty_types
    @online_credit_inputs[:client_goals] = client_goals
    @online_credit_inputs[:currencies] = currencies


    puts json: @online_credit_inputs
  end

  def index
  end

  def create
    validation_errors = validate
    return redirect_to :back, params: params, flash: {validation_errors: validation_errors,
                                                      inputs_params: params[:online_credit]} if validation_errors != nil
    @mark, @necessaryMark, @mark_explanations, @calculating = calculate_mark
  end

  def calculate_mark
    mark = 1.0
    necessaryMark = 0
    mark_explanations = []
    calculating = ""
    addition = ""
    coefficient = 0
    onlineCredit = params[:online_credit]
    case onlineCredit[:credit_product_type].to_i
      when 1
        mark_explanations.push "Клиент выбрал финансирование текущей деятельности в качестве вида кредита, коэфициент равен 1"
        calculating = "1"
      when 2
        mark_explanations.push "Клиент выбрал финансирование инвестиционной деятельности в качестве вида кредита, коэфициент равен 1"
        calculating = "1"
      when 3
        mark_explanations.push "Клиент выбрал факторинг в качестве вида кредита, коэфициент равен 1.5"
        mark = mark * 1.5
        calculating = "1.5"
      when 4
        mark_explanations.push "Клиент выбрал лизинг в качестве вида кредита, коэфициент равен 1.5"
        mark = mark * 1.5
        calculating = "1.5"
      when 5
        mark_explanations.push "Клиент выбрал банковскую гарантию в качестве вида кредита, коэфициент равен 2"
        mark = mark * 2.0
        calculating = "2"
    end
    case onlineCredit[:currency_type].to_i
      when 3
        mark_explanations.push "Клиент выбрал белорусские рубли, коэфициент валюты 0.0001, коэфициент рассчёта оценки = 1"
        calculating = "#{calculating}*1"
        addition = "BYR"
        coefficient = 0.0001
      when 2
        mark_explanations.push "Клиент выбрал евро, коэфициент валюты и коэфициент рассчёта оценки равен 0.97"
        mark = mark * 0.97
        calculating = "#{calculating}*0.97"
        addition = "EUR"
        coefficient = 0.97
      when 1
        mark_explanations.push "Клиент выбрал доллары, коэфициент валюты и коэфициент рассчёта оценки равен 0.95"
        mark = mark * 0.95
        coefficient = 0.95
        calculating = "#{calculating}*0.95"
        addition = "$"
    end

    necessaryMark = onlineCredit[:sum_value].to_f * coefficient.to_f
    mark_explanations.push("Сумма кредита составила #{onlineCredit[:sum_value] + ' ' + addition},
                            необходимая оценка будет равна (Сумма / коэфициент валюты ) #{necessaryMark}")

    mark_explanations.push("Срок кредита будет равен #{onlineCredit[:term_loan_product].to_i},
                            коэфициент равен #{(onlineCredit[:term_loan_product].to_f / 6.0).round(2)}")
    mark = mark * (onlineCredit[:term_loan_product].to_f / 6.0)
    calculating = "#{calculating}*#{(onlineCredit[:term_loan_product].to_f / 6.0.to_f).round(2)}"


    markSum = 0.0
    isMarkSetted = false
    if onlineCredit[:provision_type] == "0"
      mark_explanations.push("В качестве видов обеспечения клиент выбрал #{onlineCredit[:other_provision_type]},
                              коэфициент равен 0.3")
      markSum = 0.3
      calculating = "#{calculating}*(0.3+"
      isMarkSetted = true
    else
      calculating = "#{calculating}("
      onlineCredit[:provision_type].split(",").each do |e|
        case e.to_i
          when 1
            mark_explanations.push "Клиент выбрал залог товаров в обороте, коэфициент равен 0.3"
            markSum += 0.3
            calculating = "#{calculating}+0.3"
          when 2
            mark_explanations.push "Клиент выбрал Залог недвижимости, коэфициент равен 0.5"
            markSum += 0.5
            calculating = "#{calculating}+0.5"
          when 3
            mark_explanations.push "Клиент выбрал Залог оборудования, коэфициент равен 0.4"
            markSum += 0.4
            calculating = "#{calculating}+0.4"
          when 4
            mark_explanations.push "Клиент выбрал Залог транспортных средств, коэфициент равен 0.45"
            markSum += 0.45
            calculating = "#{calculating}+0.45"
          when 5
            mark_explanations.push "Клиент выбрал Залог имущественных прав, коэфициент равен 0.41"
            markSum += 0.41
            calculating = "#{calculating}+0.41"
          when 6
            mark_explanations.push "Клиент выбрал Поручительство, коэфициент равен 0.35"
            markSum += 0.35
            calculating = "#{calculating}+0.35"
          when 7
            mark_explanations.push "Клиент выбрал гарантию, коэфициент равен 0.6"
            markSum += 0.6
            calculating = "#{calculating}+0.6"
          when 8
            mark_explanations.push "Клиент выбрал Гарантийный депозит денег, коэфициент равен 0.6"
            markSum += 0.6
            calculating = "#{calculating}+0.6"
          when 9
            mark_explanations.push "Клиент выбрал Гарантийный депозит денег, коэфициент равен 0.8"
            markSum += 0.3
            calculating = "#{calculating}+0.8"
        end
      end
      calculating = "#{calculating})"
    end
    mark = mark * markSum
    calculating = "#{calculating})" if isMarkSetted

    case onlineCredit[:main_activity_type].to_i
      when 1
        mark_explanations.push "Клиент выбрал в качестве вида основной деятельности Грузоперевозки, коэфициент равен 1"
        calculating = "#{calculating}*1"
      when 2
        mark_explanations.push "Клиент выбрал в качестве вида основной деятельности Производство, коэфициент равен 1"
        calculating = "#{calculating}*1"
      when 3
        mark_explanations.push "Клиент выбрал в качестве вида основной деятельности сельское хозяйство, коэфициент равен 1.2"
        calculating = "#{calculating}*1.2"
        mark = mark * 1.2
      when 4
        mark_explanations.push "Клиент выбрал в качестве вида основной деятельности строительство, коэфициент равен 1.3"
        calculating = "#{calculating}*1.3"
        mark = mark * 1.3
      when 5
        mark_explanations.push "Клиент выбрал в качестве вида основной деятельности торговлю, коэфициент равен 1.4"
        calculating = "#{calculating}*1.4"
        mark = mark * 1.4
    end

    if onlineCredit[:alt_main_activity] != ""
      mark_explanations.push("Клиент выбрал в качестве вида альтернативной деятельности #{onlineCredit[:alt_main_activity]},
                              коэфициент равен 1")
      calculating = "#{calculating}*1"
    end

    mark_explanations.push "Стаж работы клиента равен #{onlineCredit[:organization_experience].to_i}, коэфициент равен #{(onlineCredit[:organization_experience].to_f / 12.0).round(2)}"
    mark = mark * (onlineCredit[:organization_experience].to_f / 12.0)
    calculating = "#{calculating}*#{(onlineCredit[:organization_experience].to_f / 12.0.to_f).round(2)}"
    mark *= onlineCredit[:salary].to_f * 0.0001 * onlineCredit[:term_loan_product].to_f
    return mark, necessaryMark, mark_explanations, calculating
  end

  def online_credit_params
    params.require(:online_credit).permit(:organization_name,
                                          :customers_address, :main_activity_type, :alt_main_activity, :organization_experience,
                                          :customers_firstname, :customers_lastname, :customers_patronymic, :customers_phone, :customers_email)
  end

  def validate
    validation_errors = []
    onlineCredit = params[:online_credit]
    validation_errors.push 'В нашем банке с такими параметрами нет кредита.' if !validate_credit_type(onlineCredit[:sum_value].to_i, onlineCredit[:term_loan_product].to_i, onlineCredit[:currency_type].to_i)
    validation_errors.push "Выберите тип кредита на 1ом шаге." if onlineCredit[:credit_product_type].to_i <= 0 || onlineCredit[:credit_product_type].to_i > 5
    validation_errors.push "Выберите валюту 2ом шаге." if onlineCredit[:currency_type].to_i <= 0 || onlineCredit[:currency_type].to_i > 3
    validation_errors.push "Введите сумму кредита большую нуля на 3ем шаге." if onlineCredit[:sum_value].to_i <= 0
    validation_errors.push "Введите срок кредита в месяцах на 4ом шаге." if onlineCredit[:term_loan_product].to_i <= 0
    validation_errors.push "Введите виды обеспечения на 5ом шаге." if onlineCredit[:other_provision_type] == "" && onlineCredit[:provision_type] == "0"
    validation_errors.push "Введите имя вашей организации на 6ом шаге." if onlineCredit[:organization_name] == ""
    validation_errors.push "Введите ваш адрес проживания на 6ом шаге." if onlineCredit[:customers_address] == ""
    validation_errors.push "Введите вид вашей деятельности на 6ом шаге." if (onlineCredit[:main_activity_type].to_i == 0 && onlineCredit[:alt_main_activity] == "") || onlineCredit[:main_activity_type].to_i > 5
    validation_errors.push "Введите ваш опыт работы на 6ом шаге." if onlineCredit[:organization_experience].to_i <= 0
    validation_errors.push "Введите ваш имя на 6ом шаге." if onlineCredit[:customers_firstname] == ""
    validation_errors.push "Введите ваш фамилию на 6ом шаге." if onlineCredit[:customers_lastname] == ""
    validation_errors.push "Введите ваш отчество на 6ом шаге." if onlineCredit[:customers_patronymic] == ""
    validation_errors.push "Введите ваш мобильный телефон на 6ом шаге." if onlineCredit[:customers_phone] == ""
    validation_errors.push "Введите вашу заработную плату на 6ом шаге." if onlineCredit[:salary].to_i < 1
    validation_errors == [] ? nil : validation_errors
  end
  def validate_credit_type(sum, term, currency_id)
    credits = Credit.all
    counter = 0
    credits.each do |credit|
      if (credit.min_sum <= sum && sum <= credit.max_sum ) &&
          (credit.min_number_of_months <= term && term <= credit.max_number_of_months) &&
          (credit.currency_id == currency_id)
        counter += 1
      end
    end
    if counter > 0
      true
    else
      false
    end
  end
end
