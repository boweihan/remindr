$(document).on('ready', function() {
  $('#autoreply_settings_form').on('submit', function(event) {
    event.preventDefault();
    $.ajax({
      type: 'GET',
      url: '/update_message?update='+$('textarea').val(),
      data: {}
    })
  });
});
