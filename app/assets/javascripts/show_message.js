$(document).on('ready', function() {

  $(document).on('click', '.individual_message',  function() {
    var summary = $(this)
    var data = $(this).attr('data');
    $(this).css('display','none');
    $('#' + data).stop().fadeIn(1000)
    $(document).on('click', '.individual_message_outer_div',  function() {
      $(this).css('display', 'none');
      summary.stop().fadeIn(1000);
    });

  });
});
