$(document).ready(function() {
  $('#send-tweet').submit(function(event) {
    event.preventDefault();
    if ($("#twitter-user-field").val()) {
      $.ajax({
        type: "post",
        url: '/tweets',
        data: {tweet: {message: $("#send-text-area").val()}}
      }).done(function(){
        $("#send-text-area").val("");
      });
    }
    else {
      alert("The user does not have a twitter handle, please add a valid twitter handle for the contact")
    }
  });
});
