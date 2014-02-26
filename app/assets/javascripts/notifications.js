$(document).ready(function() {
  $('#notifications_table').on('click', '.delete', function(event){
    event.preventDefault();
    var notification_id = $(this).data().id;
    $.ajax({
      url: "/notifications/logic_delete",
      data: { notification_id: notification_id},
      data_type: 'json',
      type: 'post',
      success: function(data){
        if(data.result){
          $("#notification_" + notification_id).parent().parent().remove();
        }
      }
    });
  });
});