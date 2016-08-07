var contacts = []
$(function(){
  $(".potential-contacts").click(function(e){
    $(this).toggleClass("selected")
    console.log("been clicked")
    $('.number_of_selected_contacts').text($(".selected").length)
  })

  $("#import_contact_button").click(function(e){
    e.preventDefault()

    $(".selected").each(function(i,item){
      var info = {}
      info.name = $(item).find(".potential-contact-name").text()
      info.phone = $(item).find(".potential-contact-phone-number").val()
      info.email= $(item).find(".potential-contact-email").text()
      info.category = 'friend'
      $.ajax({
        url:"/contacts",
        method:"post",
        data: {contact: info}
      });
    });

    window.location.replace("/newsfeed");
  })
})
