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

  $('#teachers-table-admin').on('click', '.change-status', function(event){
    event.preventDefault();
    var teacher_id = $(this).data().id;
    $.ajax({
      url: "/teachers/inactivate_or_activate",
      data: { teacher_id: teacher_id},
      data_type: 'json',
      type: 'post',
      success: function(data){
        if(data.result){
          if (data.inactive)
            $("#teacher_" + teacher_id, '#teachers-table-admin').html("Activar");
          else
            $("#teacher_" + teacher_id, '#teachers-table-admin').html("Inactivar");
        }
      }
    });
  });
});