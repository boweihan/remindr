$(document).ready(function() {
  $('#send-direct-message').submit(function(event) {
    event.preventDefault();
    $.ajax({
      type: "get",
      url: '/direct_messages',
      data: {direct_message: {user: $("#twitter-user-field").val(), text: $("#twitter-text-area").val()}}
    }).done(function(){
      // $("#twitter_id_field").val("");
      $("#twitter-text-area").val("");
      $("#twitter-user-field").val("");
    });
  });
});
