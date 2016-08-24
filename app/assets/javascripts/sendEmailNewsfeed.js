$(document).ready(function() {
  $('#send_email').submit(function(event) {
    event.preventDefault();
    var receiver = $("#email_field").val()
    var subject = $("#subject_field").val()
    var body = $("#body_field").val()

    if (receiver == ""){
      alert("Contact has no email")
    }
    else{
      $.ajax({
        type: "post",
        url: '/send',
        data: {receiver: receiver, subj: subject, bod: body}
      }).done(function(){
        $("#email_field").val("")
        $("#subject_field").val("")
        $("#body_field").val("")
      });
    }


  });
});
