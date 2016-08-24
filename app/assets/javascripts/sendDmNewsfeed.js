$(document).ready(function() {
  $('#send-direct-message').submit(function(event) {
    event.preventDefault();
    if ($("#twitter-user-field").val()) {
      $.ajax({
        type: "post",
        url: '/direct_messages',
        data: {direct_message: {user: $("#twitter-user-field").val(), text: $("#twitter-text-area").val()}}
      }).done(function(){
        $("#twitter-text-area").val("");
        $("#twitter-user-field").val("");
      }).fail(function(){
        alert("You are not connected with Twitter.")
      })
    }
    else {
      alert("The contact does not have a twitter handle, please add a valid twitter handle for the contact")
    }
  });
});
