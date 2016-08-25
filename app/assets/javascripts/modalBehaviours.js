$(function() {
  $('.add-contact-button').on('click', function(e) {
    $('.modal').css('display', 'block');
  })

  $('.modal').on('click', function() {
    $('.modal').css('display', 'none')
  });

  $('.signup').on('click', function(e) {
    e.preventDefault();
    $(".login-modal").css("display","none");
    $('.sign-up-modal').css('display', 'block');
  });

  $('.sign-up-modal').on('click', function() {
    $('.sign-up-modal').css('display', 'none');
  });

  $('.loginButton').on('click', function(e) {
    e.preventDefault();
    $(".sign-up-modal").css("display","none");
    $('.login-modal').css('display', 'block');
  });


  $('.login-modal').on('click', function() {
    $('.login-modal').css('display', 'none');
  })

  $('.edit-modal').on('click', function() {
    $('.edit-modal').css('display', 'none')
  });

  $('.close').on('click', function() {
    $('.edit-modal').css('display', 'none');
    $('.login-modal').css('display', 'none');
    $('.modal').css('display', 'none');
    $('.sign-up-modal').css('display', 'none');
  });

  $(".add-contact, .field, .login-form, #password, #signup-confirmation, #signup-field, .sign-up-form").click(function(e){
    e.stopPropagation();
  })

  $('.getstarted').on('click', function(e) {
    if ($('.sign-up-modal').length !== 0) {
      e.preventDefault();
      $("html, body").animate({ scrollTop: 0 }, "medium");
      $('.login-modal').css('display', 'none');
      $('.sign-up-modal').css('display', 'block');
    }
    else {
      e.preventDefault();
      window.location.replace("/newsfeed");
    }
  })
})
