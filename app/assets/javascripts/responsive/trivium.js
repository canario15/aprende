$(document).ready(function() {
  $('#trivia_level').change(function(){
    var level = $(this).val();
    $.ajax({
      type:'GET',
      url: '/trivium/update_course/',
      data: { level_id: level },
      success: function(data){
        if (data){
        	$('#trivia_course_id').find('option').remove();
        	var courses = data.courses;
          $('#trivia_course_id').append('<option value>Cursos</option>');
        	for (var i= 0; i < courses.length; i++) {
        		$('#trivia_course_id').append('<option value="' + courses[i].id + '">'+ courses[i].title +'</option>');
        	};
        }
      }
    });
  });

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
