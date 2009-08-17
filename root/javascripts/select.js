// When the page is ready
//
$(document).ready(function(){
  // Hide the full description
  $(".activity .thebody").hide();
  
  // Toggle hiding thebody
  $(".actions li.readbody a").click(function(event){
    $(this).parents("ul").next(".thebody").toggle();
    // Stop the link click from doing its normal thing
    return false;
  });


});
