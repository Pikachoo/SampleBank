function validateElementWithNullify(elementSelector, errorsId, message) {
    if (!isElementGreaterThanZero(elementSelector))
        addErrorMessage(errorsId, message);
}

function validateNumbersForGreatest(greaterNumber, lesserNumber, errorsId, message) {
    if (greaterNumber < lesserNumber)
        addErrorMessage(errorsId, message);
}

function validateNumbersForEquals(firstNumber, secondNumber, errorsId, message) {
    if (firstNumber != secondNumber)
        addErrorMessage(errorsId, message);
}

function validateElementWithEmptiness(elementSelector, errorsId, message) {
    if (!isElementNotEmpty(elementSelector))
        addErrorMessage(errorsId, message);
}
function validateElementWithMaxMin(elementSelector, errorsId, message) {
    if (!isInRange(elementSelector))
        addErrorMessage(errorsId, message);
}
function isElementGreaterThanZero(elementSelector) {
    return $(elementSelector).val() != undefined && $(elementSelector).val() > 0;
}
function isInRange(elementSelector) {
    var value = Number($(elementSelector).val());
    var min = Number($(elementSelector).attr('min'));
    var max = Number($(elementSelector).attr('max'));
    return value >= min && value <= max;

}
function isElementNotEmpty(elementSelector) {
    return $(elementSelector).val() != undefined && $(elementSelector).val() != "";
}

function addErrorMessage(errorsId, message) {
    $("#errors-list-" + errorsId).append("<li>" + message + "</li>");
    toggleElement('#step-errors-' + errorsId, true);
}

function validateToggledElement(elementSelector, elementValue, toogledElementId, errorsId, message) {
    if ($(elementSelector).val() == elementValue && $("#" + toogledElementId).val() == "")
        addErrorMessage(errorsId, message);
}

function prepareToValidation(errorsId) {
    $("#step-errors-" + errorsId).hide();
    $("#errors-list-" + errorsId).empty();
};

function navigateAfterValidation(boardSelector, step) {
    if ($(boardSelector).is(':hidden') == true) {
        navigateAndToggle(step);
    }
}

//Step form validations
function validateFirstCreditStep() {
    prepareToValidation(1);
    validateElementWithNullify("[name='credit_type']:checked", 1, "Выберите тип кредита");
    $("#bank_credit_credit_type").val($("[name='credit_type']:checked").val());
    validateElementWithNullify("#bank_credit_granted_procedure", 1, "Выберите порядок предоставления");
    validateElementWithNullify("#bank_credit_issuance_method", 1, "Выберите способ выдачи");
    if ($('#credit_affirmation').text() != '') {
        validateElementWithNullify("#bank_credit_affirmation_of_commitments", 1, "Выберите вид обеспечения исполнения кредитных обязательств");
    }
    //if ($("#bank_credit_collateral_customer").val() != '') {
    //    validateElementWithNullify("#bank_credit_collateral_customer", 1, "Выберите Сумму залога клиента большую чем ноль");
    //}
    //if ($("#bank_credit_collateral_employee").val() != '') {
    //    validateElementWithNullify("#bank_credit_collateral_employee", 1, "Введите оценку суммы залога клиента большую чем ноль");
    //}
    validateElementWithNullify("[name='score_existance']:checked", 1, "Укажите, имеется ли з.п. или доходы в нашем банке");
    validateToggledElement("[name='credit_type']:checked", 4, "bank_credit_another_home_credit_type", 1, "Укажите вид кредита на финансирование имущества");
    validateToggledElement("[name='credit_type']:checked", 6, "bank_credit_credit_type_another_car", 1, "Укажите вид автокредита");
    validateToggledElement("[name='credit_type']:checked", 8, "bank_credit_credit_type_another_card", 1, "Укажите вид кредитных карт");
    validateToggledElement("[name='score_existance']:checked", 1, "bank_credit_account_id", 1, "Укажите номер счёта");
    $("#bank_credit_score_existance").val($("[name='score_existance']:checked").val());
    navigateAfterValidation("#step-errors-1", 1);
}

function validateEmail(email) {
    var re = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    return re.test(email);
}

function validateSecondCreditStep() {
    prepareToValidation(2);
    validateElementWithNullify("#bank_credit_credit_sum", 2, "Укажите сумму кредита");
    validateElementWithMaxMin("#bank_credit_credit_sum", 2, "Укажите правильную сумму кредита (В порядке от " + $(bank_credit_credit_sum).attr('min') + " до " + $(bank_credit_credit_sum).attr('max') + ")");
    validateElementWithNullify("#bank_credit_credit_term", 2, "Укажите колличество месяцев до конца оплаты");
    validateElementWithMaxMin("#bank_credit_credit_term", 2, "Укажите правильное количество месяцев до конца оплаты (от " + $(bank_credit_credit_term).attr('min') + " до " + $(bank_credit_credit_term).attr('max') + ") месяцев");
    validateElementWithNullify("#bank_credit_make_insurance", 2, "Укажите информацию о страховании клиента");
    validateElementWithNullify("#bank_credit_repayment_method", 2, "Укажите способ погашения кредита");
    navigateAfterValidation("#step-errors-2", 2);
}
function validateTelephon(telephone, step, error) {
    var match_str = telephone.match(/^[\+]\d*/);
    if (telephone != '') {
        if (match_str != null) {
            if (match_str[0].length != 13) {
                addErrorMessage(step, error);
            }
        }
        else {
            addErrorMessage(step, error);
        }
    }

}


function validateApplicant(step, id) {
    prepareToValidation(step);
    validateElementWithEmptiness("#bank_credit_" + id + "_firstname", step, "Укажите имя");
    validateElementWithEmptiness("#bank_credit_" + id + "_lastname", step, "Укажите фамилию");
    validateElementWithEmptiness("#bank_credit_" + id + "_patronymic", step, "Укажите отчество");
    validateElementWithEmptiness("#bank_credit_" + id + "_birthdate", step, "Укажите день рождения");
    validateElementWithEmptiness("#bank_credit_" + id + "_id", step, "Укажите идентификационный номер");
    validateElementWithNullify("#bank_credit_" + id + "_age", step, "Укажите возраст");
    var age = Math.floor((new Date() - new Date($("#bank_credit_" + id + "_birthdate").val())) / 31536000000);
    validateNumbersForEquals(age, $("#bank_credit_" + id + "_age").val(), step, "Убедитесь в правильности ввода возраста и дня рождения");
    var livingAge = $("#bank_credit_" + id + "_rb_age").val();
    if (livingAge > 0)
        validateNumbersForGreatest($("#bank_credit_" + id + "_age").val(), livingAge, step, "Убедитесь в правильности ввода возраста и срока проживания в Республике Беларусь.");
    if ($("#bank_credit_customer_age").val() < 18)
        addErrorMessage(step, "Наш банк не работает с несовершеннолетними.");
    validateElementWithEmptiness("#bank_credit_" + id + "_country", step, "Укажите гражданство");
    validateElementWithEmptiness("#bank_credit_" + id + "_birthplace", step, "Укажите место рождения");
    validateElementWithNullify("#bank_credit_" + id + "_family_status", step, "Укажите семейное положение");
    validateElementWithNullify("#bank_credit_" + id + "_living_conditions", step, "Укажите жилищные условия");
    validateToggledElement("#bank_credit_" + id + "_living_conditions", 8, "bank_credit_" + id + "_another_living_conditions", step, "Укажите место проживания");
    validateElementWithNullify("#bank_credit_" + id + "_education", step, "Укажите образование клиента");
    validateElementWithNullify("#bank_credit_" + id + "_military_conditions", step, "Укажите отношение к воинской службе");
    validateToggledElement("#bank_credit_" + id + "_military_conditions", 3, "bank_credit_" + id + "_reprieve_end_date", step, "Укажите срок окончания отсрочки");
    validateElementWithNullify("#bank_credit_" + id + "_name_info", step, "Укажите менялось ли ФИО");
    validateToggledElement("#bank_creditСоздан _" + id + "_name_info", 1, "bank_credit_" + id + "_changing_reason", step, "Укажите причину смены фио");
    validateElementWithEmptiness("#bank_credit_" + id + "_document_type", step, "Укажите наименование документа");
    validateElementWithEmptiness("#bank_credit_" + id + "_document_series", step, "Укажите серию документа");
    validateElementWithEmptiness("#bank_credit_" + id + "_document_number", step, "Укажите номер документа");
    validateElementWithEmptiness("#bank_credit_" + id + "_document_given_date", step, "Укажите дату выдачи документа");
    validateElementWithEmptiness("#bank_credit_" + id + "_document_end_date", step, "Укажите дату окончания документа");
    if (new Date($("#bank_credit_" + id + "_document_end_date").val()) <= new Date($("#bank_credit_" + id + "_document_given_date").val()))
        addErrorMessage(step, "Укажите корректные данны о даче выдачи и окончания документа");
    if (new Date($("#bank_credit_" + id + "_document_given_date").val()) >= new Date())
        addErrorMessage(step, "Убедитесь что вы правильно указали дату выдачи документа.");
    if (new Date($("#bank_credit_" + id + "_document_end_date").val()) <= new Date())
        addErrorMessage(step, "Убедитесь что вы правильно указали дату окончания документа.");
    validateElementWithEmptiness('#bank_credit_customer_mobile_phone', step, 'Укажите мобильный телефон');
    validateTelephon($('#bank_credit_customer_mobile_phone').val(), step, 'Укажите правильно мобильный телефон');
    validateTelephon($('#bank_credit_customer_work_phone').val(), step, 'Укажите правильно рабочий телефон');
    validateTelephon($('#bank_credit_customer_actual_phone').val(), step, 'Укажите правильно домашний телефон');
    validateTelephon($('#bank_credit_customer_constant_phone').val(), step, 'Укажите правильно домашний телефон');

    validateElementWithEmptiness("#bank_credit_" + id + "_registration_address", step, "Укажите адрес регистрации по месту жительства");
    //validateElementWithEmptiness("#bank_credit_" + id + "_registration_place", step, "Укажите адрес регистрации по месту пребывания");
    validateElementWithEmptiness("#bank_credit_" + id + "_actual_living_place", step, "Укажите адрес места фактического проживания");
    validateElementWithNullify("#bank_credit_" + id + "_living_age", step, "Укажите срок проживания клиента по фактическому адресу");
    var livingAgeRb = $("#bank_credit_" + id + "_living_age").val();
    validateNumbersForGreatest($("#bank_credit_" + id + "_age").val(), livingAgeRb, step, "Убедитесь в правильности ввода возраста и срока проживания по фактическому месту жительства.");
    if (step == 3) {
        if (validateEmail($("#bank_credit_customer_email").val()) == false) {
            addErrorMessage(step, "Введите e-mail в правильном формате.");
        }
    }
    navigateAfterValidation("#step-errors-" + step, step);
}

function validateThirdCreditStep() {
    validateApplicant(3, "customer");
}

function validateJobCreditStep(step, id) {
    prepareToValidation(step);
    validateElementWithNullify("#bank_credit_" + id + "_employment_type", step, "Укажите тип работы клиента");
    if ($("#bank_credit_" + id + "_employment_type").val() == 4 || $("#bank_credit_" + id + "_employment_type").val() == 10)
        return navigateAfterValidation("#step-errors-" + step, step);
    validateToggledElement("#bank_credit_" + id + "_employment_type", 9, "bank_credit_" + id + "_practical_employment", step, "Уточните тип практики.");
    validateToggledElement("#bank_credit_" + id + "_employment_type", 11, "bank_credit_" + id + "_another_employment", step, "Уточните тип занятости.");
    validateElementWithEmptiness("#bank_credit_" + id + "_start_job_date", step, "Укажите начало работы клиента");
    validateElementWithEmptiness("#bank_credit_" + id + "_end_job_date", step, "Укажите срок окончания работы клиента");
    if (new Date($("#bank_credit_" + id + "_end_job_date").val()) <= new Date($("#bank_credit_" + id + "_start_job_date").val()))
        addErrorMessage(step, "Укажите верные данны о начале работы и конце контракта клиента");
    validateElementWithEmptiness("#bank_credit_" + id + "_organization_name", step, "Укажите наименование организации");
    validateElementWithEmptiness("#bank_credit_" + id + "_job_name", step, "Укажите должность клиента");
    validateElementWithEmptiness("#bank_credit_" + id + "_organization_address", step, "Укажите адресс организации клиента");
    validateElementWithNullify("#bank_credit_" + id + "_activity_status", step, "Укажите сферу деятельности клиента");
    validateElementWithNullify("#bank_credit_" + id + "_employers_count", step, "Укажите численность работающих в организации");
    validateElementWithNullify("#bank_credit_" + id + "_experience_in_organization", step, "Укажите стаж работы клиента");
    validateElementWithNullify("#bank_credit_" + id + "_job_category", step, "Укажите категорию занимаемой должности клиента");
    validateToggledElement("#bank_credit_" + id + "_job_category", 9, "bank_credit_" + id + "_owners_percent", step, "Укажите процент от доходов предприятия.");
    var job_changing = $("#bank_credit_" + id + "_job_changing_value").val();
    if (job_changing < 0)
        addErrorMessage(step, "Убедитесь в правильности ввода колличества смен работы за последние три года(они должны быть положительными).");
    if (job_changing > 0)
        validateNumbersForGreatest($("#bank_credit_" + id + "_job_changing_value").val(), 30, step, "Убедитесь в правильности ввода колличества смен работы(максимум 30, минимум 0).");
    navigateAfterValidation("#step-errors-" + step, step);
}

function validateFourthCreditStep() {
    validateJobCreditStep(4, "customer");
}

function validateFifthCreditStep() {
    $("#skipSixStepButton").show();
    validateJobCreditStep(5, "customer_additional");
    if ($("#bank_credit_customer_family_status").val() == 3 || $("#bank_credit_customer_family_status").val() == 4)
        $("#skipSixStepButton").hide();
}

function validateSixthCreditStep() {
    if ($("#bank_credit_customer_family_status").val() == 3 || $("#bank_credit_customer_family_status").val() == 4)
        return validateApplicant(6, "partner");
    navigateAfterValidation("#step-errors-" + 6, 6);
}

function validateNinthStep() {
    prepareToValidation(7);
    validateElementWithNullify("#bank_credit_last_incomings", 7, "Укажите среднемесячные доходы");
    validateElementWithNullify("#bank_credit_last_outcomings", 7, "Укажите среднемесячные расходы");
    validateElementWithNullify("#bank_credit_family_incomings", 7, "Укажите среднемесячные доходы семьи");
    validateElementWithNullify("#bank_credit_salary", 7, "Укажите заработную плату");
    navigateAfterValidation("#step-errors-" + 7, 7);
}

function validateTenthStep() {
    prepareToValidation(8);
    validateElementWithNullify("[name='another_contracts']:checked", 8, "Укажите наличие ограничений со стороны других банков");
    $("#bank_credit_another_contracts").val($("[name='another_contracts']:checked").val());
    validateElementWithNullify("[name='unfinushed_contracts']:checked", 8, "Укажите наличие судебных решений по отношению к клиенту");
    $("#bank_credit_unfinushed_contracts").val($("[name='another_contracts']:checked").val());
    validateElementWithNullify("[name='mental_desease']:checked", 8, "Укажите состояние на учёте клиента у психиатра или психолога");
    $("#bank_credit_mental_desease").val($("[name='mental_desease']:checked").val());
    validateElementWithNullify("[name='guilty_contracts']:checked", 8, "Укажите является ли клиент обвиняемым в данный момент");
    $("#bank_credit_guilty_contracts").val($("[name='guilty_contracts']:checked").val());
    validateElementWithNullify("[name='is_punished']:checked", 8, "Укажите приговорён ли клиент в данный момент");
    $("#bank_credit_is_punished").val($("[name='is_punished']:checked").val());
    validateElementWithNullify("[name='partner_unfinushed_contracts']:checked", 8, "Укажите наличие судебных решений по отношению к супругу клиента");
    $("#bank_credit_partner_unfinushed_contracts").val($("[name='partner_unfinushed_contracts']:checked").val());
    validateElementWithNullify("[name='partner_mental_desease']:checked", 8, "Укажите состояние на учёте супруг клиента у психиатра или психолога");
    $("#bank_credit_partner_mental_desease").val($("[name='partner_mental_desease']:checked").val());
    validateElementWithNullify("[name='partner_guilty_contracts']:checked", 8, "Укажите является ли супруг клиента обвиняемым в данный момент");
    $("#bank_credit_partner_guilty_contracts").val($("[name='partner_guilty_contracts']:checked").val());
    validateElementWithNullify("[name='partner_is_punished']:checked", 8, "Укажите приговорён ли супруг клиента в данный момент");
    $("#bank_credit_partner_is_punished").val($("[name='partner_is_punished']:checked").val());
    navigateAfterValidation("#step-errors-8", 8);
}

function validateEleventhStep() {
    prepareToValidation(9);
    validateElementWithNullify("[name='rude_credits']:checked", 9, "Укажите наличие опыта кредитование в Rude-bank");
    $("#bank_credit_rude_credits").val($("[name='rude_credits']:checked").val());
    validateElementWithNullify("[name='another_credits']:checked", 9, "Укажите наличие опыта кредитование в других банках");
    $("#bank_credit_another_credits").val($("[name='another_credits']:checked").val());
    validateElementWithNullify("[name='credit_violation']:checked", 9, "Укажите наличие случаев нарушения кредита");
    $("#bank_credit_credit_violation").val($("[name='credit_violation']:checked").val());
    validateElementWithNullify("[name='percent_violation']:checked", 9, "Укажите наличие случаев нарушения процентов");
    $("#bank_credit_percent_violation").val($("[name='percent_violation']:checked").val());
    validateElementWithNullify("[name='another_banks_credits']:checked", 9, "Укажите наличие поручительства в других банках");
    $("#bank_credit_another_banks_credits").val($("[name='another_banks_credits']:checked").val());
    validateElementWithNullify("[name='guarantee']:checked", 9, "Укажите наличие денежных обязательств");
    $("#bank_credit_guarantee").val($("[name='guarantee']:checked").val());
    validateElementWithNullify("[name='installments']:checked", 9, "Укажите наличие задолженности по товарам в рассрочку");
    $("#bank_credit_installments").val($("[name='installments']:checked").val());

    if ($("#step-errors-9").is(':hidden') == true) {
        toggleElement('#step-errors-9', false);
        $("#bank-credits-form").submit();
    }
}
