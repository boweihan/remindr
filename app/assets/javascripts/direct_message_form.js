$(document).ready(function() {
  $('#send_direct_message').submit(function(event) {
    event.preventDefault();
    $.ajax({
      type: "GET",
      url: '/directmessage',
      data: {receiver: $("#twitter_id_field").val(), direct_message: $("#direct_message_field").val()}
    }).done(function(){
      $("#twitter_id_field").val("");
      $("#direct_message_field").val("");
    });
  });
});
