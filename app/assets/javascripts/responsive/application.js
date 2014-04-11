// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require ckeditor-jquery
//= require twitter/bootstrap
//= require chosen-jquery
//= require_tree .
//= require_self

$(document).ready(function(){
  $("#close").on("click", function() {
      $("#welcome-message").hide();
  });

  $("select").on('change',function(){
    $(this).toggleClass('placeholder',($(this).val()==""));

    if($(this).attr("id")=="state_id"){
      var cities = $("select[id=cities]");
      cities.addClass('placeholder');
      cities.children('option:not(:first)').remove();
    }
  });

  $(".contents_selection").change(function() {
    $("div[id*='div_containable_']").addClass("hide").removeClass("show");
    $("input[class*='hidden_field_'").val("");

    var selected = $(".contents_selection option:selected").text();
    $(".hidden_field_"+selected).val(selected);
    $("div[id*='div_containable_"+selected+"']").addClass("show").removeClass("hide");
  });

  // $('.ckeditor_read_only').ckeditor({
  //   ToolbarStartExpanded: false,
  //   toolbar: [],
  //   readOnly: true,
  //   removePlugins: 'elementspath, Anchor',
  //   resize_enabled: false,
  //   width: "100%",
  //   height:"400px"
  //  });
});

