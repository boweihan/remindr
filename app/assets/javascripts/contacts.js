$( function() {

  $('.close').on('click', function() {
    $('.modal').css('display', 'none')
    })

  $('.add-icon').on('click', function() {
    $('.modal').css('display', 'block')
  })

  $('.modal').on('click', function() {
    $('.modal').css('display', 'none')
  });

  $('.field').on('click', function(e) {
    e.stopPropagation();
    $(this).css('border', '1px solid green')
  });

  })
