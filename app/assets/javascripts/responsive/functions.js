// JavaScript Functions ( Statti Template )
$(document).ready(function () {

  /* --- Active Filter Menu --- */
  $(".switch-section a i, .filter a").click(function (e) {
    $(".switch-section a i, .filter a").removeClass("active");
    $(this).addClass("active");
    e.preventDefault();
  });

  /* --- Masonry --- */
  var $container = $(".masonry");
  $container.imagesLoaded(function () {
    $container.isotope({
      itemSelector: ".item"
    });
  });
  $("#folio-filters a, #blog-filters a").click(function () {
    var selector = $(this).attr("data-filter");
    $container.isotope({
      filter: selector
    });
    return false;
  });

  /* --- Item Description --- */
  $(".item .icon-play-circle").click(function () {
    $(this).closest('div.item').toggleClass("open");
  })

  $(".item-close").click(function () {
    $(this).closest('div.item').toggleClass("open");
  })

  /* --- Fancybox --- */
  $(".view-fancybox").fancybox({
    openEffect: 'elastic',
    closeEffect: 'elastic',
    next: '<i class="icon-smile"></i>',
    prev: '<a title="Previous" class="fancybox-nav fancybox-prev" href="javascript:;"><span></span></a>'
  });

  /* --- NiceScroll --- */
  $(".section").niceScroll();

  /* --- Slider --- */
  $('#slides').superslides({
    slide_easing: 'easeInOutCubic',
    slide_speed: 800,
    play: 4000,
    pagination: true,
    hashchange: true,
    scrollable: true
  });

  $("#avatar_preview").click(function(){
    $("#avatar_field").trigger('click');
  });

  $('#avatar_field').on("change", function(evt){
    $('#avatar_preview').find('span').remove();
    if(evt.target.files.length == 0){
      var img = $('<img/>',{
        "class":"img-thumbnail","src":"/assets/default_" + $(".section").attr('data-type') +".png",
        "title": "default student",
        "class":"default"})
      var span = $('<span/>').append(img)
      $('#avatar_preview').append(span)
    }
    else{
      var file = evt.target.files[0];
      if (file.type.match('image.*')) {
        var reader = new FileReader();
        reader.onload = (function(f) {
          return function(e) {
            var img = $('<img/>',{"class":"img-thumbnail","src":e.target.result, "title": escape(f.name), "width": 210})
            var span = $('<span/>').append(img )
            $('#avatar_preview').append(span)
          };
        })(file);
        reader.readAsDataURL(file);
      }
    }
  });
});

/* --- Flex Slider --- */
$(window).load(function() {
  $(".flexslider").flexslider({
    animation: "slide",
    animationLoop: true,
    itemWidth: 300,
    itemMargin: 0,
    prevText: "<i class='icon-angle-left'></i>",
    nextText: "<i class='icon-angle-right'></i>",
  });
});
