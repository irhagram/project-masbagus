$(function(){
	window.addEventListener('message', function(event) {
		if (event.data.action == "setValue"){
			setValue(event.data.key, event.data.value)
		}else if (event.data.action == "toggle"){
			if (event.data.show){
				$('#ui').show();
			} else{
				$('#ui').hide();
			}
		}
	});
});

function setValue(key, value){
	$('#'+key+' span').html(value)
}