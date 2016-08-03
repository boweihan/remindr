$(function(){
  $(".reminder_choices").on("click",function(){
    var clicked=$(this)
    $.ajax({
      url: "/reminders/change_type",
      method: "POST",
      data: {type: clicked.attr("id")}
    }).done(function(){
      $(".selected_platform").attr("class","reminder_choices")
      clicked.attr("class","reminder_choices selected_platform")
    })
  })
})
