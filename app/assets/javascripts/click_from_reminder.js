$(document).on('ready', function() {
  if (window.location.href.split("/")[3].indexOf('newsfeed') > -1) {
    $('#'+window.location.href.split("#")[1]).click();
    console.log('hello');
  }
})
