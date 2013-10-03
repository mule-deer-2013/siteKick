 $(function () {
     var icons = {
         header: "iconClosed",
         activeHeader: "iconOpen"
     };
     $("#accordion").accordion({
         icons: icons,
         collapsible: true,
         active: false, 
         heightStyle: "content"
     });
 });









// Luisa's 
// $(function() {

//   $("#accordion").accordion({header:"h3", collapsible: true, active:2});

//   $('.ui-accordion-header').on("click", function(){

//       $('h1').css("background-color", "yellow");
//     })

// });
