// $(function(){
//
//   $("#edit_contact").on("submit",function(){
//     $(".all-contacts-scroll-div").html("")
//     var form = $("#edit_contact")
//     $(".edit-modal").click()
//     var contact_id = form.attr("action").split("/")[2]
//     window.all_contacts.forEach(function(contact){
//       if (String(contact.id) === contact_id){
//         console.log("i'm her")
//         contact.name = form.find("#contact-name").val()
//         contact.phone = form.find("#contact-phone").val()
//         contact.email = form.find("#contact-email").val()
//         contact.category = form.find("#contact_category").val()
//         contact.twitter_username = form.find("#contact-twitter").val()
//         return contact
//       }
//     })
//   window.all_contacts.forEach(fill_with_contacts);
//   })
//
//   // $("#new_contact").on("submit",function(e){
//   //   var form = $(this)
//   //   e.preventDefault();
//   //   $.ajax({
//   //     url: "/contacts",
//   //     method: "POST",
//   //     data:form.serialize()
//   //   }).done(function(){
//   //     alert("DONE")
//   //   })
//   //   $(".all-contacts-scroll-div").html("")
//   //   var form = $("#new_contact")
//   //   $(".modal").click()
//   //   var contact_id = form.attr("action").split("/")[2]
//   //   var name = form.find("#contact-name").val()
//   //   var phone = form.find("#contact-phone").val()
//   //   var email = form.find("#contact-email").val()
//   //   var category = form.find("#contact_category").val()
//   //   var twitter_username = form.find("#contact-twitter").val()
//   //
//   //   var contact = {name: name, phone: phone, email: email, category: category, twitter_username: twitter_username, show: true }
//   //   window.all_contacts.push(contact)
//   //   window.all_contacts.forEach(fill_with_contacts);
//   // })
// })
