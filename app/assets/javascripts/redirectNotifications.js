$(function(){
  $('.reminderbox').on('click', function() {
    var id = $(this).data('identifier');
    window.location.replace("/newsfeed#"+id);
  });
})
