
$(function() {

  $('.article_content h2').on('click', function(e) {
    e.preventDefault()
    $('.feedback_text').text($('.main_messages').text())
  })

  $('h1').on('click', function(e) {
    e.preventDefault()
    $('.feedback_text').text($('.h1_messages').text())
  })


});