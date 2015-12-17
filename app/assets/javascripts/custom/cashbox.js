
function add_error(str)
{
    $("#errors_list").append(str);
}

function validateCash() {
    var validateErrorsCount = 0;
    $("#errors_list").empty();

    if ($("#cashbox_sum").val() == "" || $("#cashbox_sum").val() <= 0){
        validateErrorsCount++;
        add_error("<li>Укажите вносимую сумму.</li>");
    }
    if ($("#cashbox_credit_number").val() == ""){
        validateErrorsCount++;
        add_error("<li>Укажите номер кредита.</li>");
    }


    if ($("#cashbox_currency").val()  ==  ""){
        validateErrorsCount++;
        add_error("<li>Укажите валюту.</li>");
    }

    if (validateErrorsCount == 0)
        $("#cashbox_form").submit();
    else{
        toggleElement('#step-errors', true);
    }

}
function validateCreditPayments() {
    var validateErrorsCount = 0;
    $("#errors_list").empty();

    if ($("#cashbox_credit_number").val() == ""){
        validateErrorsCount++;
        add_error("<li>Укажите номер кредита.</li>");
    }

    if (validateErrorsCount == 0)
        $("#cashbox_form").submit();
    else{
        toggleElement('#step-errors', true);
    }

}

