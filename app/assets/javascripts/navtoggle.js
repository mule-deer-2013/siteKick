$(function() {

$("button").click(function(){
   var $this = $(this);
  $this.toggleClass('show_button');
  $("#togglediv").toggle("slow");
    if ($this.hasClass('show_button')){
      $this.text('Hide Feedback');
    } else {
      $this.text('Show Feedback');
    }
})

});
