$('document').ready(function(){
	$('#step1').show();
    $('.ui.accordion').accordion();
});

function navigate(navigationId) {
	$('.step').hide();
	$(navigationId).show();
}

function toggleElement(elementId, visibilityValue) {
    if ($(elementId).is(':hidden') == visibilityValue)
        $(elementId).toggle(200);
}