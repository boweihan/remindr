$(function(){

  $(document).on("click", "div.contact-message", function(){
    $("div.contact-message").removeAttr("id")
    $(this).attr("id","contact_clicked")
  })
})
