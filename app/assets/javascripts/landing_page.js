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
  });

  $('.loginButton').on('click', function(e) {
    e.preventDefault();
    $('.login-modal').css('display', 'block');
  });

  $('.close').on('click', function() {
    $('.login-modal').css('display', 'none');
  });

  $('.login-modal').on('click', function() {
    $('.login-modal').css('display', 'none');
  })

  $('.getstarted').on('click', function(e) {
    // alert("hi")
    // $('.sign-up-modal').css('display', 'block');

    if ($('.sign-up-modal').length !== 0) {
      e.preventDefault();
      $('.sign-up-modal').css('display', 'none');
      $('.login-modal').css('display', 'none');
      $('.sign-up-modal').css('display', 'block');
    }
    else {
      e.preventDefault();
      window.location.replace("/newsfeed");
    }

  })

  $('.field, #password, #signup-confirmation, #signup-field, .sign-up-form').on('click', function(e) {

    e.stopPropagation();
  })
})
