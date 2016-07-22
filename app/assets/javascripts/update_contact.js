$(function(){
  $("#update_contact").submit(function(event){
    event.preventDefault();
    var attribute = $("#field").find(":selected").val()
    console.log(attribute)
    if (attribute ===  undefined){
      alert("invalid attribute")
      return false;
    }

    var info = $("#contact_new_info").val()
    var contact_id = $("#contact_id").val()
    $.ajax({
      url: "/contacts/"+contact_id,
      method: "PATCH",
      datatype: "script",
      data: {attribute:attribute,new:info}
    }).done(function(){
      //validate if type is valid no html validation
      $("#contact_new_info").val("")
      $("#inner_details").append(attribute[0].toUpperCase()+attribute.slice(1)+": "+info)
    })
  })
})
