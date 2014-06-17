$(document).ready(function() {
  
  $('#save_and_finish').click(function(){
    $("#finish").val("true");
  });


  $('#display_question_trivia').click(function(){
    var questionCount = $('#questions td').length;
    var text          = 'Agregar Pregunta';

    if ($('.question_trivia').hasClass('hide')) {
      text = 'Volver';
      $('#new_question').slideDown('slow').toggleClass('hide');
    }else{
      $('#new_question').slideUp('slow').toggleClass('hide');
      $('#trivia-questions').show();
    }
    if (questionCount >= 1) {
      $(this).find('span').toggleClass('icon-plus-sign icon-undo').text(text);
    }
  });

  $('#save_question').click(function(){
    var form = $('#new_question');
    $.ajax({
      url: form.attr('action'),
      type: form.attr('method'),
      data: form.serialize()
    });
  });
});
