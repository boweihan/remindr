$(document).on('ready', function() {
  $(window).on('scroll', function() {
    var position = $(window).scrollTop();
    console.log($('.photo-background-image').css('margin-top'))
    $('.photo-background-image').css('margin-top', position/2.5)
  });
});
