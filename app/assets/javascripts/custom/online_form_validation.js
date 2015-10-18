function validateSimpleStep(validationId, step) {
    if ($("#" + validationId).val() > 0) {
        navigateAndToggle(step);
    }
    else{
        toggleElement('#step-errors-' + step, true);
    }
}

function navigateAndToggle(step) {
    toggleElement('#step-errors-' + step, false);
    navigate('#step' + (step + 1));
}

function validateFifthStep() {
    if ($("#online_credit_provision_type").val() != "0" || $("#online_credit_other_provision_type").val() != "")
        navigateAndToggle(5);
    else{
        toggleElement('#step-errors-5', true);
    }
}

function validateSixthStep() {
    var validateErrorsCount = 0;
    $("#errors_list").empty();

    if ($("#online_credit_organization_name").val() == ""){
        validateErrorsCount++;
        $("#errors_list").append("<li>Укажите наименование организации, в которой работает клиент.</li>");
    }
    if ($("#online_credit_customers_address").val() == ""){
        validateErrorsCount++;
        $("#errors_list").append("<li>Укажите адрес проживания клиента.</li>");
    }
    if ($("#online_credit_main_activity_type").val() == 0 && $("#online_credit_alt_main_activity").val() == ""){
        validateErrorsCount++;
        $("#errors_list").append("<li>Вид деятельности клиента.</li>");
    }
    if ($("#online_credit_customers_firstname").val() == ""){
        validateErrorsCount++;
        $("#errors_list").append("<li>Укажите имя клиента.</li>");
    }
    if ($("#online_credit_customers_lastname").val() == ""){
        validateErrorsCount++;
        $("#errors_list").append("<li>Укажите фамилию клиента.</li>");
    }
    if ($("#online_credit_customers_patronymic").val() == ""){
        validateErrorsCount++;
        $("#errors_list").append("<li>Укажите отчество клиента.</li>");
    }
    if ($("#online_credit_customers_phone").val() == ""){
        validateErrorsCount++;
        $("#errors_list").append("<li>Укажите номер телефона клиента.</li>");
    }
    if (validateErrorsCount == 0)
        $("#online-credit-form").submit();
    else{
        toggleElement('#step-errors-6', true);
    }

}