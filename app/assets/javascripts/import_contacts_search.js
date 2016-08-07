$(function() {
  if (window.location.href.split("/")[3].indexOf('import_contacts') > -1) {
    $.ajax({
      method: "GET",
      url: "/import_contacts.json",
      datatype: "json"
    }).done(function(response){
      all_contacts = response
      response.forEach(load_imported_contacts);
    });

    $("#search_imported_contacts").on("submit",function(event){
      event.preventDefault()
    });

    $(".import-search-bar").keyup(function(){
      var query= $(".import-search-bar").val()
      var similar = duplicated_elements2(query,all_contacts)
      $(".potential-contacts-container").html("")
      similar.forEach(function(contact){
        load_imported_contacts(contact)
      });
    });
  }
});

function load_imported_contacts(contact){
  if (contact.name !== "") {
    $(".potential-contacts-container").append("<div class='potential-contacts'><h2 class='potential-contact-name'>"+contact.name+"</h2><h4 class='potential-contact-email'>"+contact.email+"</h4></div>")
  }
  else {
    $(".potential-contacts-container").append("<div class='potential-contacts'><h2 class='potential-contact-name'>"+contact.email.split("@")[0]+"</h2><h4 class='potential-contact-email'>"+contact.email+"</h4></div>")
  }
}

//<input type='hidden' class='potential-contact-phone-number' name='phone_number'>"+contact.phone+"</input>

function duplicated_elements2(searchterm,contactsjson){
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
