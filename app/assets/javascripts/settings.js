$( function() {

  $('.close').on('click', function() {
    $('.modal2').css('display', 'none')
  });

  $('.settings-icon').on('click', function() {
    $('.modal2').css('display', 'block')
  });

  $('.modal2').on('click', function() {
    $('.modal2').css('display', 'none')
  });

  // $('.field').on('click', function(e) {
  //   e.stopPropagation();
  //   $(this).css('border', '1px solid green')
  // });

})
