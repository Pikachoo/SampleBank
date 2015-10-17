function validateElementWithNullify(elementSelector, errorsId, message) {
    if (!isElementGreaterThanZero(elementSelector))
        addErrorMessage(errorsId, message);
}

function validateElementWithEmptiness(elementSelector, errorsId, message) {
    if (!isElementNotEmpty(elementSelector))
        addErrorMessage(errorsId, message);
}

function isElementGreaterThanZero(elementSelector) {
    return $(elementSelector).val() != undefined && $(elementSelector).val() > 0;
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

function prepareToValidation(errorsId){
    $("#step-errors-" + errorsId).hide();
    $("#errors-list-" + errorsId).empty();
};

function navigateAfterValidation(boardSelector, step) {
    if ($(boardSelector).is(':hidden') == true)
        navigateAndToggle(step);
}

//Step form validations
function validateFirstCreditStep() {
    prepareToValidation(1);
    validateElementWithNullify("[name='credit_type']:checked", 1, "Выберите тип кредита");
    validateElementWithNullify("#granted_procedure", 1, "Выберите порядок предоставления");
    validateElementWithNullify("#issuance_method", 1, "Выберите способ выдачи");
    validateElementWithNullify("#affirmation_of_commitments", 1, "Выберите вид обеспечения исполнения кредитных обязательств");
    validateElementWithNullify("[name='score_existance']:checked", 1, "Укажите, имеется ли з.п. или доходы в нашем банке");
    validateToggledElement("[name='credit_type']:checked", 4, "another_home_credit_type", 1, "Укажите вид кредита на финансирование имущества");
    validateToggledElement("[name='credit_type']:checked", 6, "another_car_credit_type", 1, "Укажите вид автокредита");
    validateToggledElement("[name='credit_type']:checked", 8, "another_card_credit_type", 1, "Укажите вид кредитных карт");
    validateToggledElement("[name='score_existance']:checked", 1, "account_id", 1, "Укажите номер счёта");
    navigateAfterValidation("#step-errors-1", 1);
}

function validateSecondCreditStep() {
    prepareToValidation(2);
    validateElementWithNullify("#credit_sum", 2, "Укажите сумму кредита");
    validateElementWithNullify("#credit_term", 2, "Укажите колличество месяцев до конца оплаты");
    validateElementWithNullify("#credit_limit_term", 2, "Укажите срок освоения кредита");
    validateElementWithNullify("#make_insurance", 2, "Укажите информацию о страховании клиента");
    validateElementWithNullify("#repayment_method", 2, "Укажите способ погашения кредита");
    navigateAfterValidation("#step-errors-2", 2);
}

function validateApplicant(step, id) {
    prepareToValidation(step);
    validateElementWithEmptiness("#" + id + "-firstname", step, "Укажите имя");
    validateElementWithEmptiness("#" + id + "-lastname", step, "Укажите фамилию");
    validateElementWithEmptiness("#" + id + "-patronymic", step, "Укажите отчество");
    validateElementWithEmptiness("#" + id + "-birthdate", step, "Укажите день рождения");
    validateElementWithEmptiness("#" + id + "-id", step, "Укажите идентификационный номер");
    validateElementWithNullify("#" + id + "-age", step, "Укажите возраст");
    validateElementWithEmptiness("#" + id + "-country", step, "Укажите гражданство");
    validateElementWithEmptiness("#" + id + "-birthplace", step, "Укажите место рождения");
    validateElementWithNullify("#" + id + "_family_status", step, "Укажите семейное положение");
    validateElementWithNullify("#" + id + "_living_conditions", step, "Укажите жилищные условия");
    validateToggledElement("#" + id + "_living_conditions", 8, "" + id + "_another_living_conditions", step, "Укажите место проживания");
    validateElementWithNullify("#" + id + "_education", step, "Укажите образование клиента");
    validateElementWithNullify("#" + id + "_military_conditions", step, "Укажите отношение к воинской службе");
    validateToggledElement("#" + id + "_military_conditions", 3, "" + id + "_reprieve_end_date", step, "Укажите срок окончания отсрочки");
    validateElementWithNullify("#" + id + "_name_info", step, "Укажите менялось ли ФИО");
    validateToggledElement("#" + id + "_name_info", 1, "" + id + "_changing_reason", step, "Укажите причину смены фио");
    validateElementWithEmptiness("#" + id + "_document_type", step, "Укажите наименование документа");
    validateElementWithEmptiness("#" + id + "_document_series", step, "Укажите серию документа");
    validateElementWithEmptiness("#" + id + "_document_number", step, "Укажите номер документа");
    validateElementWithEmptiness("#" + id + "_document_given_date", step, "Укажите дату выдачи документа");
    validateElementWithEmptiness("#" + id + "_document_end_date", step, "Укажите дату окончания документа");
    validateElementWithEmptiness("#" + id + "-registration-address", step, "Укажите адрес регистрации по месту жительства");
    validateElementWithEmptiness("#" + id + "-registration-place", step, "Укажите адрес регистрации по месту пребывания");
    validateElementWithEmptiness("#" + id + "-actual-living-place", step, "Укажите адрес места фактического проживания");
    validateElementWithNullify("#c" + id + "-living-age", step, "Укажите срок проживания клиента по фактическому адресу");
    navigateAfterValidation("#step-errors-" + step, step);
}

function validateThirdCreditStep() {
    validateApplicant(3, "customer");
}

function validateJobCreditStep(step, id) {
    prepareToValidation(step);
    validateElementWithNullify("#" + id + "_employment_type", step, "Укажите тип работы клиента");
    if ($("#" + id + "_employment_type").val() == 4 || $("#" + id + "_employment_type").val() == 10 )
        return navigateAfterValidation("#step-errors-" + step, step);
    validateToggledElement("#" + id + "_employment_type", 9, "" + id + "_practical-employment", step, "Уточните тип практики.");
    validateToggledElement("#" + id + "_employment_type", 11, "" + id + "_another-employment", step, "Уточните тип занятости.");
    validateElementWithEmptiness("#" + id + "-start-job-date", step, "Укажите начало работы клиента");
    validateElementWithEmptiness("#" + id + "-end-job-date", step, "Укажите срок окончания работы клиента");
    validateElementWithEmptiness("#" + id + "_organization_name", step, "Укажите наименование организации");
    validateElementWithEmptiness("#" + id + "_job_name", step, "Укажите должность клиента");
    validateElementWithEmptiness("#" + id + "_organization_address", step, "Укажите адресс организации клиента");
    validateElementWithNullify("#" + id + "_activity_status", step, "Укажите сферу деятельности клиента");
    validateElementWithNullify("#" + id + "_employers_count", step, "Укажите численность работающих в организации");
    validateElementWithNullify("#" + id + "_experience_in_organization", step, "Укажите стаж работы клиента");
    validateElementWithNullify("#" + id + "_job_category", step, "Укажите категорию занимаемой должности клиента");
    validateToggledElement("#" + id + "_job_category", step, "" + id + "_owners_percent", step, "Укажите процент от доходов предприятия.");
    navigateAfterValidation("#step-errors-" + step, step);
}

function validateFourthCreditStep() {
    validateJobCreditStep(4, "customer");
}

function validateFifthCreditStep() {
    validateJobCreditStep(5, "customer_additional");
}

function validateSixthStep() {
    if ($("customer_family_status") == 3 || $("customer_family_status" == 4))
        return validateApplicant(6, "partner");
    navigateAfterValidation("#step-errors-" + 6, 6);
}

function validateTenthStep() {
    prepareToValidation(10);
    validateElementWithNullify("[name='another_contracts']:checked", 10, "Укажите наличие ограничений со стороны других банков");
    validateElementWithNullify("[name='unfinushed_contracts']:checked", 10, "Укажите наличие судебных решений по отношению к клиенту");
    validateElementWithNullify("[name='mental_desease']:checked", 10, "Укажите состояние на учёте клиента у психиатра или психолога");
    validateElementWithNullify("[name='guilty_contracts']:checked", 10, "Укажите является ли клиент обвиняемым в данный момент");
    validateElementWithNullify("[name='is_punished']:checked", 10, "Укажите приговорён ли клиент в данный момент");
    validateElementWithNullify("[name='partner_unfinushed_contracts']:checked", 10, "Укажите наличие судебных решений по отношению к супругу клиента");
    validateElementWithNullify("[name='partner_mental_desease']:checked", 10, "Укажите состояние на учёте супруг клиента у психиатра или психолога");
    validateElementWithNullify("[name='partner_guilty_contracts']:checked", 10, "Укажите является ли супруг клиента обвиняемым в данный момент");
    validateElementWithNullify("[name='partner_is_punished']:checked", 10, "Укажите приговорён ли супруг клиента в данный момент");
    navigateAfterValidation("#step-errors-10", 10);
}

function validateEleventhStep() {
    prepareToValidation(11);
    validateElementWithNullify("[name='another_credits']:checked", 11, "Укажите наличие опыта кредитование в Rude-bank");
    validateElementWithNullify("[name='another_credits']:checked", 11, "Укажите наличие опыта кредитование в других банках");
    validateElementWithNullify("[name='credit_violation']:checked", 11, "Укажите наличие случаев нарушения кредита");
    validateElementWithNullify("[name='percent_violation']:checked", 11, "Укажите наличие случаев нарушения процентов");
    validateElementWithNullify("[name='another_banks_credits']:checked", 11, "Укажите наличие поручительства в других банках");
    validateElementWithNullify("[name='guarantee']:checked", 11, "Укажите наличие денежных обязательств");
    validateElementWithNullify("[name='installments']:checked", 11, "Укажите наличие задолженности по товарам в рассрочку");
}
