$(function() {
  $('.signup').on('click', function(e) {
    e.preventDefault();
    $('.sign-up-modal').css('display', 'block');
  });

  $('.close').on('click', function() {
    $('.sign-up-modal').css('display', 'none');
  });

  $('.sign-up-modal').on('click', function() {
    $('.sign-up-modal').css('display', 'none');
  })

})
