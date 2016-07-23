$(function() {

  $('.pokemon-list > li > a').on('click', function(event) {
    event.preventDefault();
    $.ajax({
      url: $(this).attr('href'),
      method: "get",
      data: {},
      dataType: "json"
    }).done(function(responseData) {
      var source = $('#pokemon-template').html();
      var template = Handlebars.compile(source);
      var output = template(responseData);

      $('.pokemon-container').html(output);

    });

  });
});
