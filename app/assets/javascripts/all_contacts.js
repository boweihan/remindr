$(function() {

  $('.contact-types-wrapper > a').on('click', function(event) {
    event.preventDefault();
      $.ajax({
        url: $(this).attr('href'),
        method: "get",
        data: {},
        dataType: "json"
      }).done(function(responseData) {

        console.log(responseData);

        var source = $('#contact-template').html();
        console.log(source);

        var template = Handlebars.compile(source);

        var output = template(responseData);
        console.log(output)

        $('.contacts-area').html(output);


      }).fail(function() {
        console.log('Request failed')
      });
  });
});
