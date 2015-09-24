$('document').ready(function(){
	$('#step1').show();
    $('.ui.accordion').accordion();
});

function navigate(navigationId) {
	$('.step').hide();
	$(navigationId).show();
    //scrollTo(0, 0);
}

function toggleElement(elementId, visibilityValue) {
    if ($(elementId).is(':hidden') == visibilityValue)
        $(elementId).toggle(200);
}