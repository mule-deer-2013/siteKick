$(function() {

  $("#accordion").accordion({header:"h3", collapsible: true, active:2});

  $('.ui-accordion-header').on("click", function(){

      $('h1').css("background-color", "yellow");
    })

});