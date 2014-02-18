$(document).ready(function() {
  $('#avatar_field').on("change", function(evt){
    var file = evt.target.files[0];
    $('#avatar_preview').find('span').remove()
    if (file.type.match('image.*')) {
      var reader = new FileReader();
      reader.onload = (function(f) {
        return function(e) {
          var img = $('<img/>',{"class":"img-thumbnail","src":e.target.result, "title": escape(f.name)})
          var span = $('<span/>').append(img )
          $('#avatar_preview').append(span)
        };
      })(file);
      reader.readAsDataURL(file);
    }
  });
});