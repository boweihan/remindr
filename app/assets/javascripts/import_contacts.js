$(function(){
  $(".potential-contacts").click(function(e){
    $(this).toggleClass("selected")
    console.log("been clicked")
    if ($(this).attr("class").split(" ")[1] === "selected"){
      console.log($(this).find(".potential-contact-name")).text()
    }
  })
  $("#import_contact_button").click(function(e){
    e.preventDefault()
    selected_contacts = $(".selected")
    console.log(selected_contacts)

    selected_contacts.forEach(function(contact){
      name = contact.find(".potential-contact-name").text()
      email = contact.find(".potential-contact-email").text()
      phone_number = contact.find(".potential-contact-phone-number").val()
      info = {name: name, email: email, phone: phone_number}
      alert(info)
      // $.ajax({
      //   url:"/contacts/create".
      //   method:"post",
      //   data: {}
      // })
    })

  })
})
