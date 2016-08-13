$(function() {

    $('.edit-modal').on('click', function() {
      $('.edit-modal').css('display', 'none')
    });

    $('.close').on('click', function() {
      $('.edit-modal').css('display', 'none')
    });

    $(".add-contact").click(function(e){
      e.stopPropagation();
    })
    $('.field').on('click', function(e) {
      e.stopPropagation();
    });

    $(".login-form").on('click',function(e){
      e.stopPropagation();

    })
})
