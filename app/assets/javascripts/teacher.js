$(document).ready(function() {
  $('#teacher_state').change(function(){
    var state = $(this).val();
    $.ajax({
      type:'GET',
      url: '/cities/state_cities/',
      data: { state_id: state },
      success: function(data){
        if (data){
          $('#teacher_city_id').find('option').remove();
          var cities = data.cities;
          for (var i= 0; i < cities.length; i++) {
            $('#teacher_city_id').append('<option value="' + cities[i].id + '">'+ cities[i].name +'</option>');
          }
        }
      }
    });
  });
});