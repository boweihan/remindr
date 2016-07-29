$( function() {

  $('.close').on('click', function() {
    $('.modal').css('display', 'none')
  });

  $('add-icon-all-contacts-page').on('click', function() {
    $('.modal').css('display', 'block')
  });

  $('.modal').on('click', function() {
    $('.modal').css('display', 'none')
  });

})
