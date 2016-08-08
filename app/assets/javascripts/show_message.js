$(document).on('ready', function() {

  $(document).on('click', '.individual_message',  function() {
    var summary = $(this)
    var data = $(this).attr('data');
    $(this).css('display','none');
    $('#' + data).stop().fadeIn(1000)
    $(document).on('click', '.message_expand',  function() {
      $('.individual_message_outer_div').css('display', 'none');
      summary.css('display', 'block');
    });

  });
});
