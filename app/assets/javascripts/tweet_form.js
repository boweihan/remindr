$(document).ready(function() {
  $('#send-tweet').submit(function(event) {
    event.preventDefault();
    $.ajax({
      type: "get",
      url: '/tweets',
      data: {tweet: {message: $("#send-text-area").val()}}
    }).done(function(){
      $("#send-text-area").val("");
    });
  });
});
