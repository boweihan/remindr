$(document).on('ready', function() {
  $('.gmail-toggle').on('click', function() {
    $('.gmail-toggle').css('background-color', '#33b4ff');
    $('.gmail-toggle').css('color', 'white');
    $('.twitter-toggle, .text-toggle').css('background-color', 'white');
    $('.twitter-toggle, .text-toggle').css('color', 'black');
    $('.send-email-div').css('display','block');
    $('.send-direct-message, .send-tweet').css('display','none');
  });

  $('.twitter-toggle').on('click', function() {
    $('.twitter-toggle').css('background-color', '#33b4ff');
    $('.twitter-toggle').css('color', 'white');
    $('.gmail-toggle, .text-toggle').css('background-color', 'white');
    $('.gmail-toggle, .text-toggle').css('color', 'black');
    $('.send-direct-message').css('display','block');
    $('.send-email-div, .send-tweet').css('display','none');
  });

  $('.text-toggle').on('click', function() {
    $('.text-toggle').css('background-color', '#33b4ff');
    $('.text-toggle').css('color', 'white');
    $('.gmail-toggle, .twitter-toggle').css('background-color', 'white');
    $('.gmail-toggle, .twitter-toggle').css('color', 'black');
    $('.send-tweet').css('display','block');
    $('.send-email-div, .send-direct-message').css('display','none');
  });

  $('#message-div-small').on('click', function() {
    $('#toggle-message-div').fadeIn();
  });

  $('.close-message-pane').on('click', function() {
    $('#toggle-message-div').fadeOut();
    $('#message-div-small').css('display', 'block');
  });

});
