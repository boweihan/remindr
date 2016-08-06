$(document).on('ready', function() {
  $('.reminderbox').on('click', function() {
    var id = $(this).data('identifier');
    window.location.replace("/newsfeed#"+id);
    // here you could pass ID into the hash ('/newsfeed#' + id) but we are using that for search
  });
});
