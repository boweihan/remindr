$(document).ready(function() {
  $('#send_email').submit(function(event) {
    event.preventDefault();
    $.ajax({
      type: "post",
      url: '/send',
      data: {receiver: $("#email_field").val(), subj: $("#subject_field").val(), bod: $("#body_field").val()}
    }).done(function(){
      $("#email_field").val("")
      $("#subject_field").val("")
      $("#body_field").val("")
    });
  });
});
