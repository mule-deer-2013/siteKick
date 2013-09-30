
$(function() {

  // Need to replace this eventually, but for now, clicking on
  // 'ORIGINAL ARTICLE' reveals the 'main_messages' display.
  $('.article_content h2').on('click', function(e) {
    e.preventDefault()
    $('.feedback_text').html($('.main_messages').html())
  })

  $('h1').on('click', function(e) {
    e.preventDefault()
    $('.feedback_text').html($('.h1_messages').html())
  })


});