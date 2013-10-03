$(function () {
  replace_failing_image_icons()
});

var replace_failing_image_icons = function(){
  if ($('.title_field').text() == "false") {
    $('.title_check').attr('src', '/assets/fail1.png')
  }
  if ($('.url_field').text() == "false") {
    $('.url_check').attr('src', '/assets/fail1.png')
  }
  if ($('.word_count_field').text() == "false") {
    $('.word_count_check').attr('src', '/assets/fail1.png')
  }
  if ($('.header_field').text() == "false") {
    $('.header_check').attr('src', '/assets/fail1.png')
  }
  if ($('.images_field').text() == "false") {
    $('.images_check').attr('src', '/assets/fail1.png')
  }
  if ($('.links_field').text() == "false") {
    $('.links_check').attr('src', '/assets/fail1.png')
  }
  if ($('.content_body_field').text() == "false") {
    $('.content_body_check').attr('src', '/assets/fail1.png')
  }
}


// $('.title_check').remove()
// $('.title-tag').css('margin-left', '30px')
