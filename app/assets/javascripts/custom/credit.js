
window.api_url = window.location.origin + '/api';

window.api_part_credit = '/credit_information/';

function get_credit_information(id)
{
    //console.log(window.api_url);
    var information = json_parse(window.api_url + window.api_part_credit + id);
    var credit = construct(information.credits);
    var payments = information.payments;
    var warrenties = information.warrenties;
    var grantings = information.grantings;

    clear_dropdowns();

    payments.forEach(function(item){  payment = construct(item);
        html_payment(payment)});

    grantings.forEach(function(item){ granting = construct(item);
        html_granting(granting);});

    if(warrenties.length > 0)
    {

        html_warrenties();
        warrenties.forEach(function(item){  warrenty = construct(item);
            html_warrenty(warrenty);});
    }

    set_max_min_values(credit);
    refresh_dropdowns();

}

function set_max_min_values(credit){
    console.log(credit.max_number_of_months)
    $("#bank_credit_credit_sum").attr({
        "max" : credit.max_sum,
        "min" : credit.min_sum
    });
    $("#bank_credit_credit_term").attr({
        "max" : credit.max_number_of_months,
        "min" : credit.min_number_of_months
    });

}



function html_payment(payment){
    var selector = $('#menu_method_issuance');
    selector.append('<div class="item" data-value="' + payment.id + '">' + payment.name + '</div>');

}
function html_granting(granting){
    var selector = $('#menu_granting');
    selector.append('<div class="item" data-value="' + granting.id + '">' + granting.name + '</div>');
}
function html_warrenty(warrenty) {
    var selector = $('#menu_affirmation');
    selector.append('<div class="item" data-value="' + warrenty.id + '">' + warrenty.name + '</div>');
}

function html_warrenties(){
    var selector = $('#credit_affirmation');
    selector.append('<h3>*Предлагаю в обеспечение исполнения кредитных обязательств:</h3>');
    selector.append('<div class="ui selection dropdown" id = "dropdown_affirmation" tabindex="0"></div>');

    var drop_down_selector = $('#dropdown_affirmation');
    drop_down_selector.append('<input type="hidden" name="bank_credit[affirmation_of_commitments]" id="bank_credit_affirmation_of_commitments" />');
    drop_down_selector.append('<i class="dropdown icon"></i>');
    drop_down_selector.append('<div class="default text">Обеспечения выплат</div>');
    drop_down_selector.append('<div class="menu" id = "menu_affirmation" tabindex="-1"></div>');

    selector.append('<br/><br/>')
    html_collateral_value();
}
function html_collateral_value(){
    var selector = $('#collateral_value');

    selector.append('<h3>Предмет залога, предлагаемый в обеспечение исполнения кредитных обязательств,  оценивается:</h3>');
    selector.append('<div class="ui vertical accordion menu" id ="menu_collateral"></div>');

    $('#menu_collateral').append('<div class="item" id = "item_collateral"></div>');
    var collateral_item_selector = $('#item_collateral');

    collateral_item_selector.append('<a class="title">' +
        '<i class="dropdown icon"></i>' +
        'Оценка предмета залога (в случае его существования)</a>');
    collateral_item_selector.append('<div class="content" id = "content_collateral"></div>');
    $('#content_collateral').append('<div class="ui form" id = "form_collateral" ><br/></div>');
    var collateral_form_selector = $('#form_collateral');

    collateral_form_selector.append('<div class="field">' +
        '<label>Заявителем самостоятельно согласно внутренней оценке в сумме</label>' +
        '<input min="0" placeholder="Заявителем самостоятельно согласно внутренней оценке в сумме" type="number" name="bank_credit[collateral_customer]" id="bank_credit_collateral_customer" />' +
        '</div>');

    collateral_form_selector.append('<div class="field">'+
        '<label>По независимой оценке, определенной независимым оценщиком  в сумме</label>' +
        '<input min="0" placeholder="По независимой оценке, определенной независимым оценщиком  в сумме" type="number" name="bank_credit[collateral_employee]" id="bank_credit_collateral_employee" />' +
        '</div>');
}

function clear_dropdowns(){
    clear($('#menu_method_issuance'));
    clear($('#menu_granting'));
    clear($('#menu_affirmation'));

    clear($('#credit_affirmation'));
    clear($('#collateral_value'))
}
function refresh_dropdowns(){
    $('#dropdown_method_issuance').dropdown('refresh');
    $('#dropdown_granting').dropdown('refresh');
    $('#dropdown_affirmation').dropdown('refresh');
    $('#menu_collateral').accordion('refresh');

}
function clear(selector){
    selector.html('');
}

function json_parse(source){
    out = [];
    $.ajax({
        url: source,
        dataType: 'html',
        async: false,
        success: function (result) {
            var json_string = json_escape(result);
            out = JSON.parse(result);
        }
    });
    //console.log(out)
    return out;
}
function json_escape(string) {
    var cx = /[\u0000\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g,
        escapable = /[\\\"\x00-\x1f\x7f-\x9f\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g,
        meta = { // table of character substitutions
            '\b': '\\b',
            '\t': '\\t',
            '\n': '\\n',
            '\f': '\\f',
            '\r': '\\r',
            '"': '\\"',
            '\\': '\\\\'
        };

    escapable.lastIndex = 0;
    return escapable.test(string) ? '"' + string.replace(escapable, function (a) {
        var c = meta[a];
        return typeof c === 'string' ? c :
        '\\u' + ('0000' + a.charCodeAt(0).toString(16)).slice(-4);
    }) + '"' : '"' + string + '"';
}
function construct(obj) {
    var keys = [];
    var vals = [];

    for (var key in obj) {
        if (obj.hasOwnProperty(key)) {
            keys.push(key);
            vals.push(obj[key]);
        }
    }
    //console.log(keys)

    return new Struct(keys, vals);
}
function Struct(keys, vals) {
    var length = keys.length;

    for (var i = 0; i < length; i++) {
        switch (keys[i]) {
            case 'id':
                this.id = vals[i];
                break;
            case 'name':
                this.name = vals[i];
                break;
            case 'percent':
                this.percent = vals[i];
                break;
            case 'currency_id':
                this.currency_id = vals[i];
                break;
            case 'default_interest':
                this.default_interest = vals[i];
                break;
            case 'min_sum':
                this.min_sum = vals[i];
                break;
            case 'max_sum':
                this.max_sum = vals[i];
                break;
            case 'min_number_of_months':
                this.min_number_of_months = vals[i];
                break;
            case 'max_number_of_months':
                this.max_number_of_months = vals[i];
                break;
            default:
                break;
        }
    }

    return this;
}
