$(function(){
  $("div.potential-contacts").click(function(){
    $(this).toggleClass("selected")
    console.log("been clicked")
  })
  $("#import_contact_button").click(function(e){
    e.preventDefault()
    selected_contacts = $(".selected")
    console.log(selected_contacts)
  })
})
