
$(function() {

  $('h1').tooltip({content: "This is an H1 Tag" ,
    items: 'h1', track: true} )

  $('p').tooltip({content: "This is a p Tag" ,
    items: 'p', track: true} );

});

































// $(function() {

    // $('h1').simpletip({
    //   // config properties
    //   content: "I'm an h1 tag",
    //   fixed: false
    // });

    // $('p').simpletip({
    //   // config properties
    //   content: "I'm a p tag",
    //   fixed: true,
    //   position: top,
    //   offset: [0,0]
    // });

    //  $('a').simpletip({
    //   // config properties
    //   content: "I'm an a tag",
    //   fixed: false
    // });
//  $( "h1" ).hover(
//   function() {
//     $( this ).append( $( "<div> I am an h1 tag</div>" ).addClass("tooltip") );
//     }, function() {
//     $( this ).find( "div:last" ).remove();
//   }
// );

// });
