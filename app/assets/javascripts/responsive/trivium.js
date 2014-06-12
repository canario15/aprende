$(document).ready(function() {
  
  $('#save_and_finish').click(function(){
    $("#finish").val("true");
  });

  $('#display_question_trivia').click(function(){
    if ($('.question_trivia').hasClass('hide')) {
      $('.question_trivia').removeClass('hide');
      $('.question_trivia').addClass('show');
    }else{
     $('.question_trivia').addClass('hide');
     $('.question_trivia').removeClass('show');
    }
  });
});
