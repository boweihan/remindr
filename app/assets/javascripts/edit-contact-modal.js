$(function() {
  $('.edit-contact').on('click', function(e) {
    e.preventDefault();
    $('.edit-modal').css('display', 'block');
  });

    $('.edit-modal').on('click', function() {
      $('.edit-modal').css('display', 'none')
    });

    $('.close').on('click', function() {
      $('.edit-modal').css('display', 'none')
    });

    $('.field').on('click', function(e) {
      e.stopPropagation();
    });

    $(".login-form").on('click',function(e){
      e.stopPropagation();

    })


})
