$(document).ready(function() {
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