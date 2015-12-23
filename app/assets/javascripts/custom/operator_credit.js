
function add_error(str)
{
    $("#errors_list").append(str);
}

function validateCredit() {
    var validateErrorsCount = 0;
    $("#errors_list").empty();

    if ($("#credit_name").val() == ""){
        validateErrorsCount++;
        add_error("<li>Укажите имя кредита.</li>");
    }
    if ($("#credit_currency").val() == ""){
        validateErrorsCount++;
        add_error("<li>Укажите валюту кредиты.</li>");
    }

    var max_number_of_months = $("#credit_max_number_of_months").val();
    var min_number_of_months = $("#credit_min_number_of_months").val();

    if (min_number_of_months <= 0){
        validateErrorsCount++;
        add_error("<li>Укажите минимальный срок кредита.</li>");
    }
    if (!isInRange("#credit_min_number_of_months")){
        validateErrorsCount++;
        add_error("<li>Проверьте правильность ввода минимального срока кредита.</li>");
    }
    if (max_number_of_months <= 0){
        validateErrorsCount++;
        add_error("<li>Укажите максимальный срок кредита.</li>");
    }
    if (parseInt(max_number_of_months) < parseInt(min_number_of_months) || !isInRange("#credit_max_number_of_months")){
        validateErrorsCount++;
        add_error("<li>Проверьте правильность ввода максимального срока кредита.</li>");
    }

    var min_sum = $("#credit_min_sum").val();
    var max_sum = $("#credit_max_sum").val();
    if (min_sum <= 0 ){
        validateErrorsCount++;
        add_error("<li>Укажите минимальную сумму кредита.</li>");
    }
    if (!isInRange("#credit_min_sum")){
        validateErrorsCount++;
        add_error("<li>Проверьте правильность ввода минимальной суммы кредита.</li>");
    }
    if (max_sum <= 0  ){
        validateErrorsCount++;
        add_error("<li>Укажите максимальную сумму кредита.</li>");
    }
    if (parseInt(max_sum) < parseInt(min_sum) ||  !isInRange("#credit_max_sum")){
        validateErrorsCount++;
        add_error("<li>Проверьте правильность ввода максимально суммы кредита.</li>");
    }
    if ($("#credit_percent").val() <= 0 ){
        validateErrorsCount++;
        add_error("<li>Укажите проценты по кредиту.</li>");
    }
    if(!isInRange("#credit_percent"))
    {
        validateErrorsCount++;
        add_error("<li>Проверьте правильность ввода процентов по кредиту.</li>");
    }
    if ($("#credit_default_interest").val() <= 0 ){
        validateErrorsCount++;
        add_error("<li>Укажите штрафные проценты по кредиту.</li>");
    }
    if (!isInRange("#credit_default_interest")){
        validateErrorsCount++;
        add_error("<li>Проверьте правильность ввода штрафных процентов по кредиту.</li>");
    }
    if ($("#credit_granting_type").val() == "0" || $("#credit_granting_type").val() == "" || $("#credit_granting_type").val() == undefined){
        validateErrorsCount++;
        add_error("<li>Укажите порядок предоставления.</li>");
    }
    if ($("#credit_payment_type").val() == "0" || $("#credit_payment_type").val() == "" || $("#credit_payment_type").val() == undefined){
        validateErrorsCount++;
        add_error("<li>Укажите способ выдачи кредита.</li>");
    }
    if (validateErrorsCount == 0)
        $("#credit_form").submit();
    else{
        toggleElement('#step-errors', true);
    }

}

