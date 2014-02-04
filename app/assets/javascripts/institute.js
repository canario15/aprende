$(document).ready(function() {
  $('#institute_state').change(function(){
    var state = $(this).val();
    $.ajax({
      type:'GET',
      url: '/institutes/update_city/',
      data: { state_id: state },
      success: function(data){
        if (data){
        	$('#institute_city_id').find('option').remove();
        	var cities = data.cities;
        	for (var i= 0; i < cities.length; i++) {
        		$('#institute_city_id').append('<option value="' + cities[i].id + '">'+ cities[i].name +'</option>');
        	};
        }
      }
    });
  });
});