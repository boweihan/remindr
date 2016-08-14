$(document).on('ready', function() {
  $('#reload-messages').on('click', function(e) {
    $('.loading-modal').css('display', 'block');
    setInterval( function() {
      var wait = $('.inner-loading-modal');
      if  ( wait.text().length > 23 ) {
          wait.text('Getting new messages');
      }
      else {
        wait.text(wait.text()+'.')
      }
    }, 300);

  });
});
