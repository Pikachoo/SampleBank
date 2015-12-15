
function add_error(str)
{
    $("#errors_list").append(str);
}

function validateDate() {
    var validateErrorsCount = 0;
    $("#errors_list").empty();

    if ($("#timemachine_date").val() == "" || $("#timemachine_date").val() <= 0){
        validateErrorsCount++;
        add_error("<li>Укажите дату.</li>");
    }

    if (validateErrorsCount == 0)
        $("#time_form").submit();
    else{

        console.log('dsa');
        toggleElement('#step-errors', true);
    }

}

