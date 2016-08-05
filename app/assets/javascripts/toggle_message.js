$(document).on('ready', function() {
  $('.gmail-toggle').on('click', function() {
    $('.gmail-toggle').css('background-color', 'lightgray');
    $('.twitter-toggle, .text-toggle').css('background-color', 'white');
    $('.send-email-div').css('display','block');
    $('.send-direct-message').css('display','none');
  });

  $('.twitter-toggle').on('click', function() {
    $('.twitter-toggle').css('background-color', 'lightgray');
    $('.gmail-toggle, .text-toggle').css('background-color', 'white');
    $('.send-direct-message').css('display','block');
    $('.send-email-div').css('display','none');
  });

  $('.text-toggle').on('click', function() {
    $('.text-toggle').css('background-color', 'lightgray');
    $('.gmail-toggle, .twitter-toggle').css('background-color', 'white');
  });
});
