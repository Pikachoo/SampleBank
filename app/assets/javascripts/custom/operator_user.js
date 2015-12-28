
function add_error(str)
{
    $("#errors_list").append(str);
}
function validate_telephon(telephone,  error) {
    var match_str = telephone.match(/^[\+]\d*/);
    if (telephone != '') {
        if (match_str != null) {
            if (match_str[0].length != 13) {
                add_error( error);
                return false

            }
        }
        else {
            add_error( error);
            return false
        }
    }
    return true

}
function validateUser() {
    var validateErrorsCount = 0;
    $("#errors_list").empty();
    if ($("#user_man_name").val() == ""){
        validateErrorsCount++;
        add_error("<li>Укажите имя сотрудника.</li>");
    }
    if ($("#user_man_surname").val() == ""){
        validateErrorsCount++;
        add_error("<li>Укажите фамилию сотрудника.</li>");
    }
    if ($("#user_man_mobile_phone").val() == ""){
        validateErrorsCount++;
        add_error("<li>Укажите телефон сотрудника.</li>");
    }
    if ($("#user_man_email").val() == ""){
        validateErrorsCount++;
        add_error("<li>Укажите email сотрудника.</li>");
    }
    if (!validate_telephon($('#user_man_mobile_phone').val(), 'Укажите правильно мобильный телефон') ) {
        validateErrorsCount++;
    }

    if ($("#user_man_patronymic").val() == ""){
        validateErrorsCount++;
        add_error("<li>Укажите отчетство сотрудника.</li>");
    }
    if ($("#user_name").val() == ""){
        validateErrorsCount++;
        add_error("<li>Укажите имя пользователя.</li>");
    }
    if ($("#user_role_id").val() == ""){
        validateErrorsCount++;
        add_error("<li>Укажите роль пользователя.</li>");
    }

    if (validateErrorsCount == 0)
        $("#user_form").submit();
    else{
        toggleElement('#step-errors', true);
    }

}
function validateEditUser() {
    var validateErrorsCount = 0;
    $("#errors_list").empty();

    if ($("#user_name").val() == ""){
        validateErrorsCount++;
        add_error("<li>Укажите имя пользователя.</li>");
    }
    if ($("#user_role_id").val() == ""){
        validateErrorsCount++;
        add_error("<li>Укажите роль пользователя.</li>");
    }

    if (validateErrorsCount == 0)
        $("#user_form").submit();
    else{
        toggleElement('#step-errors', true);
    }

}

