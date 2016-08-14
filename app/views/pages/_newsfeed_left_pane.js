$(function() {


    $.ajax({
      method: "GET",
      url: "/contacts.json",
      datatype: "json"
    }).done(function(response){
      all_contacts = response
      response.forEach(load_contacts);

      if ($(".contact-message")[0]){
        $(".contact-message")[0].click();
      }

    })

    $("#search_contact").on("submit",function(event){
      event.preventDefault();
    })

    $(".search-bar-field").keyup(function(){
      var query= $(".search-bar-field").val()
      $("#message-content").html("")
      var similar = similar_elements(query,all_contacts)
      $(".contacts-messages").html("")
      similar.forEach(function(contact){
        load_contacts(contact)
      })
      if ($(".contact-message")[0]){
        $(".contact-message")[0].click();
      }

    })


})

function load_contacts(contact){
  var base_path = "/contacts/"
  var id_num = contact.id
  var html_id = "contact_id-"+id_num
  var name = contact.name
  var path = base_path+id_num
  var randnum = Math.floor(Math.random()*4)
  $(".contacts-messages").append("<a href="+path+" data-remote=true class=contact-name-link><div id="+html_id+">")
  $("#"+html_id).html("<div class=contact-message><div class=contact-profile-image"+randnum+"></div><div class=contact-last-message><p>"+name+"</p><p class=last-message-on>"+contact.category+"</p></div></div>")
}

function similar_elements(searchterm,contactsjson){
  console.log('here')
    var names = []
    contactsjson.forEach(function(contact){
      if (isSubstring(searchterm, contact)){
        names.push(contact)
      }
    })
    return names
  }
