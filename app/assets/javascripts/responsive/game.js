$(document).ready(function() {

  $('#next_question').click(function(){
    $("#user_answer").remove();
    $("#user_question").removeClass('hide');
  });

  $("input[name='select_answer']").change(function() {
    $('#validate_answer').removeAttr('disabled');
  });

  $("#select_answer").keypress(function() {
    validate_answer_empty($(this));
  });

  $("#select_answer").blur(function() {
    validate_answer_empty($(this));
  });

  function validate_answer_empty(object){
    var answer = object.val().trim();
    if(answer != ""){
      $('#validate_answer').removeAttr('disabled');
    }else{
      $('#validate_answer').attr('disabled', true);
    }
  }

  $(".thumbnail.answer").on("click", function(){
    $(this).toggleClass('answer');
  });

});