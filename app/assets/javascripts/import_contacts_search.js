$(function() {
  if (window.location.href.split("/")[3].indexOf('import_contacts') > -1) {
    importContactButton();
    $.ajax({
      method: "GET",
      url: "/import_contacts.json",
      datatype: "json"
    }).done(function(response){
      window.all_contacts = response
      response.forEach(load_imported_contacts);
      clickable();
    });

    $("#search_imported_contacts").on("submit",function(event){
      event.preventDefault();
    });

    $(".import-search-bar").keyup(function(){
      var query= $(".import-search-bar").val()
      var similar = duplicated_elements(query,window.all_contacts)
      $(".potential-contacts-container").html("")
      similar.forEach(load_imported_contacts);
      clickable();
      //the code below is busted, @jon let me know if you need it
      // similar.forEach(function(contact){
      //   load_imported_contacts(contact)
      //   clickable();
      // });
    });
  }
});

function clickable(){
  $(".potential-contacts").click(function(e){
    $(this).toggleClass("selected")
    $('.number_of_selected_contacts').text($(".selected").length)
  })
}

function importContactButton(){

  $("#import_contact_button").click(function(e){
    e.preventDefault()

    $(".selected").each(function(i,item){
      var info = {}
      info.name = $(item).find(".potential-contact-name").text()
      info.phone = $(item).find(".potential-contact-phone-number").val()
      info.email= $(item).find(".potential-contact-email").text()
      info.category = 'friend'
      console.log(info);
      $.ajax({
        url:"/contacts",
        method:"post",
        data: {contact: info}
      });
    });
    
    window.location.replace("/newsfeed");
  })
}
function load_imported_contacts(contact){
  if (contact.name !== "") {
    $(".potential-contacts-container").append("<div class='potential-contacts'><h2 class='potential-contact-name'>"+contact.name+"</h2><h4 class='potential-contact-email'>"+contact.email+"</h4></div>")
  }
  else if (contact.email) {
    $(".potential-contacts-container").append("<div class='potential-contacts'><h2 class='potential-contact-name'>"+contact.email.split("@")[0]+"</h2><h4 class='potential-contact-email'>"+contact.email+"</h4></div>")
    var contact_name = contact.email.split("@")[0]
    update_all_contacts(contact.email, contact_name)
  }
  else{
    $(".potential-contacts-container").append("<div class='potential-contacts'><h2 class='potential-contact-name'>"+"No Name"+"</h2><h4 class='potential-contact-email'>"+contact.email+"</h4></div>")
  }
}

function update_all_contacts(contact_email, contact_name) {
  window.all_contacts.forEach(function(contact){
    if (contact['email'] === contact_email) {
      contact['name'] = contact_name
    }
  })
}

//<input type='hidden' class='potential-contact-phone-number' name='phone_number'>"+contact.phone+"</input>

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
