var contacts = []
$(function(){
  $(".potential-contacts").click(function(e){
    $(this).toggleClass("selected")
    console.log("been clicked")
  })

  $("#import_contact_button").click(function(e){
    e.preventDefault()

    $(".selected").each(function(i,item){
      var info = {}
      info.name = $(item).find(".potential-contact-name").text()
      info.phone = $(item).find(".potential-contact-phone-number").val()
      info.email= $(item).find(".potential-contact-email").text()
      $.ajax({
        url:"/contacts",
        method:"post",
        data: {contact: info}
      })
    })
  })
})
