// When the page is ready
//
$(document).ready(function(){
   // do something
   $(".waitlist").addClass("red");
   $(".chact").each(function(){
      $(this).addClass("box");
      var act_child = split("_", $(this).attr("id"));
      // activity_id = act_child[0]  child_id = act_child[1]
      $(this).find("a.act_enr").click(function(){
         $.get("/admin/enrollment/enroll_js/" + act_child[0] + "/" + act_child[1],
               function(data){
             alert("Child enrolled:" + data);
         });
         $(this).remove();
         
      });
      $(this).find("a.act_wait").click(function(){
         $.get("/admin/enrollment/waitlist_js/" + act_child[0] + "/" + act_child[1],
               function(data){
             alert("Child waitlisted:" + data);
         });
      });
      $(this).find("a.act_rem").click(function(){
         $.get("/admin/enrollment/remove_js/" + act_child[0] + "/" + act_child[1],
               function(data){
             alert("Child removed" + data);
         });
      });
   });
   $("a.act_enr").click(function(){
      return confirm("You are enrolling...");
   }); 
   $("a.act_wait").click(function(){
      return confirm("You are waitlisting...");
   }); 
   $("a.act_rem").click(function(){
      return confirm("You are removing...");
   }); 
});
