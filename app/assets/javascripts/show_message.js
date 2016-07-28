$(document).on('ready', function() {
  $(document).on('click', '.individual_message',  function() {
    data = $(this).attr('data')
    $('#' + data).css('display', 'block');
  });
});
