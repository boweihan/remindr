$(function() {
  if (window.location.href.split("/")[3].indexOf('newsfeed') > -1) {
    $.ajax({
      method: "GET",
      url: "/contacts.json",
      datatype: "json"
    }).done(function(response){
      all_contacts = response
      response.forEach(load_contacts);
      if (window.location.href.split("/")[3] !== 'newsfeed') {
        var target_div_id = '#'+window.location.href.split("#")[1]
        $(target_div_id).find(".contact-message").attr("id","contact_clicked")
        $(target_div_id).click()
      } else {
        $(".contact-message")[0].click();
      }

    })

    $('.close').on('click', function() {
      $('.modal').css('display', 'none')
      })

    $('.add-icon').on('click', function() {
      $('.modal').css('display', 'block')
    })

    $('.modal').on('click', function() {
      $('.modal').css('display', 'none')
    });

    $('.phoneField, .phoneField2, .phoneField3, #contact_email, .field, .eField, .catField, .twitField, .twitField2').on('click', function(e) {
      e.stopPropagation();
      $(this).css('border', '1px solid green')
    });

    $('.phoneField, .phoneField2, .phoneField3, #contact_email, .field').on('click', function(e) {
      e.stopPropagation();
      $(this).css('border', '1px solid green')
    });



    $("#search_contact").on("submit",function(event){
      event.preventDefault();
    })

    $(".search-bar-field").keyup(function(){
      var query= $(".search-bar-field").val()
      var similar = duplicated_elements(query,all_contacts)
      $(".contacts-messages").html("")
      similar.forEach(function(contact){
        load_contacts(contact)
      })
    })
  }
})

function load_contacts(contact){
  var base_path = "/contacts/"
  var id_num = contact.id
  var html_id = "contact_id-"+id_num
  var name = contact.name
  var path = base_path+id_num
  $(".contacts-messages").append("<a href="+path+" data-remote=true class=contact-name-link><div id="+html_id+">")
  $("#"+html_id).html("<div class=contact-message><div class=contact-profile-image></div><div class=contact-last-message><p>"+name+"</p><p class=last-message-on>"+contact.category+"</p></div></div>")
}

function duplicated_elements(searchterm,contactsjson){
    var names = []
    contactsjson.forEach(function(contact){
      if (isSubstring(searchterm, contact)){
        names.push(contact)
      }
    })
    return names
  }

function isSubstring(searchterm,contact){
  var searchterm = searchterm.toLowerCase()

  var iterations= contact.name.length-searchterm.length+1
  if (iterations<0) {
    iterations = 0
  }
  for (i=0;i<=iterations;i++){
    var end_index = searchterm.length+i
    if (searchterm === contact.name.toLowerCase().slice(i,end_index)){
      return true
    }
  }
}
