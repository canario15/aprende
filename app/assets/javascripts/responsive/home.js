 $(document).ready(function(){
 /* Searcher */
  var searched = false;
  function clean_searcher(){
    if(searched){
      $.get("/home/search");
      searched = false;
    }
  }

  $('body').click(function (e){
      if ( !$('#search-btn').is(e.target)
        && !$(".item").is(e.target)
        && !$("#search-input").is(e.target)
        && $('#search-btn').has(e.target).length === 0
        && $(".item").has(e.target).length === 0
        && $("#search-input").has(e.target).length === 0)
      {
          $('#search-btn').removeClass('section-open');
          $('#search-div').removeClass('section-open');
          $('#search-div').addClass('hidden');
          $("#search-input").val("");
          clean_searcher();
      }
  });

  $('#search-btn').click(function(){
    $('#search-btn').toggleClass('section-open');
    $('#search-div').toggleClass('hidden section-open');
    $("#search-input").val("");
    clean_searcher();
  });

  $( "#search-input" ).keyup(function(e) {
    var query = $(this).val();
    if(query.length > 2){
      $.get("/home/search" ,{search:{q:query}});
      searched =true;
    }
    else
      clean_searcher();
  });
});