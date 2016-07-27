$(document).ready(function() {
  $('#send-direct-message').submit(function(event) {
    event.preventDefault();
    $.ajax({
      type: "get",
      url: '/direct_messages',
      data: {direct_message: {user: $("#username").val(), text: $("#direct_message_field").val()}}
    }).done(function(){
      $("#twitter_id_field").val("");
      $("#direct_message_field").val("");
      $("#username").val("");
    });
  });
});
