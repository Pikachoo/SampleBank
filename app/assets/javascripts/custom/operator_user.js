
function add_error(str)
{
    $("#errors_list").append(str);
}

function validateUser() {
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

