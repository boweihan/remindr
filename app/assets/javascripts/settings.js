$( function() {

  $('.close').on('click', function() {
    $('.modal2').css('display', 'none')
  });

  $('#nav-icon').on('click', function() {
    $('.modal2').css('display', 'block')
  });

  $('.modal2').on('click', function() {
    $('.modal2').css('display', 'none')
  });

})
