$(function() {
$('.add-contact-button').on('click', function(e) {
  e.preventDefault();
  $('.modal').css('display', 'block');
})

$('.field').on('click', function(e) {
  e.stopPropagation();
})

$('.close').on('click', function() {
  $('.modal').css('display', 'none')
});

$('.modal').on('click', function() {
  $('.modal').css('display', 'none')
});

})
