$(document).ready(function() {
  $('#send-tweet').submit(function(event) {
    event.preventDefault();
    $.ajax({
      type: "get",
      url: '/tweets',
      data: {tweet: {message: $("#tweet-message-field").val()}}
    }).done(function(){
      $("#tweet-message-field").val("");
    });
  });
});
