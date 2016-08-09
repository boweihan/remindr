$( function() {

  $('.close').on('click', function() {
    $('.modal').css('display', 'none')
  });

  $('.add-icon-all-contacts-page').on('click', function() {
    $('.modal').css('display', 'block')
  });

  $('.modal').on('click', function() {
    $('.modal').css('display', 'none')
  });

  $('.field, .phoneField, .phoneField2, .phoneField3, .eField, .catField, .twitField2, .add-contact').on('click', function(e) {
    e.stopPropagation();
  });

})
