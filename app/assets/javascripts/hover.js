$(function() {

    $('h1').simpletip({
      // config properties
      content: "I'm an h1 tag",
      fixed: false
    });

    $('p').simpletip({
      // config properties
      content: "I'm a p tag",
      fixed: true,
      position: top,
      offset: [0,0]
    });

     $('a').simpletip({
      // config properties
      content: "I'm an a tag",
      fixed: false
    });
//  $( "h1" ).hover(
//   function() {
//     $( this ).append( $( "<div> I am an h1 tag</div>" ).addClass("tooltip") );
//     }, function() {
//     $( this ).find( "div:last" ).remove();
//   }
// );

});
