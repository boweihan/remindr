$(function(){

  $(document).on('click', '.individual_message',function() {
    var clicked = $(this)
    if ($(".message_clicked").length > 0){
      $(".message_clicked").css("display","block")
      $(".message_clicked").parent().find(".individual_message_outer_div").css("display","none")
      $(".message_clicked").toggleClass("message_clicked")

      clicked.toggleClass("message_clicked")
      clicked.css("display","none")
      clicked.parent().find(".individual_message_outer_div").css("display","block")
    }
    else {
      clicked.toggleClass("message_clicked")
      clicked.css("display","none")
      clicked.parent().find(".individual_message_outer_div").css("display","block")
    }
  });

  $(document).on("click", ".individual_message_outer_div .message_expand",function(){
    $(this).parent().css("display","none")
    $(this).parent().parent().find(".individual_message").css("display","block")
    $(this).parent().parent().find(".individual_message").toggleClass("message_clicked")

  })

});
