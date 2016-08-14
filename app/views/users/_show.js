$(function(){
    $.ajax({
      method: "GET",
      url: "/contacts.json",
      datatype: "json"
    }).done(function(response){
      window.all_contacts = response
      console.log(window.all_contacts)

      response.forEach(fill_with_contacts);
      var target_div = $(".all-contacts-scroll-div")
    })


    $(".search-contacts-user-page").keyup(function(){
      var query = $(".search-contacts-user-page").val()
      duplicated_elements(query)
      $(".all-contacts-scroll-div").html("")
      window.all_contacts.forEach(fill_with_contacts);

    })
    $("#filter-contacts-form select").on("change",function(){
      var query = $(this).val()
      if (query !== "all") {
      right_category(query)
      $(".all-contacts-scroll-div").html("")
      window.all_contacts.forEach(fill_with_contacts);
      }
      else {
        window.all_contacts.forEach(function(contact){
          contact.show = true
        })
        window.all_contacts.forEach(fill_with_contacts);

      }
    })
})

function right_category(query){
  window.all_contacts.forEach(function(contact){
    if (query === contact.category){
      contact.show = true
    }
    else {
      contact.show = false
    }
  })
}

function fill_with_contacts(contact){
  if (contact.show === true){
    var base_path = "/contacts/"
    var id_num = contact.id
    var category = contact.category
    var name = contact.name
    var email = contact.email
    var path = base_path+id_num+"/edit"
    var twitter_username = contact.twitter_username
    var randnum = Math.floor(Math.random()*4)
    $(".all-contacts-scroll-div").append("<div class=wrapper><a href="+path+" data-remote=true class=contact-name-link><div class=contact-cards-user-page edit-contact><div class=contact-profile-picture"+randnum+"></div><div class=contact-card-information><h4 class=twenty-font not-link>"+name+"</h4><h6 class=sixteen-font not-link>"+category+"</h6>"+"<h6 class=sixteen-font not-link>"+email+"</h6><h6 class=sixteen=font not-link>"+twitter_username+"</h6></div></div><a href=/contacts/"+id_num+" class=edit-link data-method=delete confirm="+"Are you sure you want to delete this contact?>Delete")
  }
}

function duplicated_elements(searchterm){

    window.all_contacts.forEach(function(contact){
      if (isSubstring(searchterm, contact)){
        contact.show = true
      }
      else {
        contact.show = false
      }
    })
}
