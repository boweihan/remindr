$(function() {

// on page load - contacts div will populate with all contacts info 
  $.ajax({
    url: '/contacts/all',
    method: "get",
    data: {},
    dataType: "json"
  }).done(function(responseData) {
    var source = $('#contact-template').html();
    var template = Handlebars.compile(source);
    var output = template(responseData);
    $('.contacts-area').html(output);

  }).fail(function() {
    console.log('Request failed')
  });


  $('.contact-types-wrapper > a').on('click', function(event) {
    event.preventDefault();
      $.ajax({
        url: $(this).attr('href'),
        method: "get",
        data: {},
        dataType: "json"
      }).done(function(responseData) {
        var source = $('#contact-template').html();
        var template = Handlebars.compile(source);

        var output = template(responseData);
        $('.contacts-area').html(output);

      }).fail(function() {
        console.log('Request failed')
      });
  });
});
