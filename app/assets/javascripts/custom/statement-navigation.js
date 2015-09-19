$('document').ready(function(){
	$('#step1').show();
});

function navigate(navigationId) {
	$('.step').hide();
	$(navigationId).show();
}