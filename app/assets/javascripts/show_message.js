$(document).on('ready', function() {
  $(document).on('click', '.individual_message',  function() {
    var summary = $(this)
    var data = $(this).attr('data');
    $(this).css('display','none');
    $('#' + data).css('display', 'block');
    $(document).on('click', '.individual_message_outer_div',  function() {
      $(this).css('display', 'none');
      summary.css('display','block');
    });

  });
});
