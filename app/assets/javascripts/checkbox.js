$(function () {
  replace_failing_image_icons()
});

var replace_failing_image_icons = function(){
  if ($('.title_field').text() == "false") {
    $('.title_check').attr('src', '/assets/fail1.png')
  }
  else if ($('.title_field').text() == "not_evaluated") {
    $('.title_check').remove()
    $('.title-tag').css('margin-left', '30px')
  }
  if ($('.url_field').text() == "false") {
    $('.url_check').attr('src', '/assets/fail1.png')
  }
  else if ($('.url_field').text() == "not_evaluated") {
    $('.url_check').remove()
    $('.url-tag').css('margin-left', '30px')
  }
  if ($('.word_count_field').text() == "false") {
    $('.word_count_check').attr('src', '/assets/fail1.png')
  }
  else if ($('.word_count_field').text() == "not_evaluated") {
    $('.word_count_check').remove()
    $('.word_count-tag').css('margin-left', '30px')
  }
  if ($('.header_field').text() == "false") {
    $('.header_check').attr('src', '/assets/fail1.png')
  }
  else if ($('.header_field').text() == "not_evaluated") {
    $('.header_check').remove()
    $('.header-tag').css('margin-left', '30px')
  }
  if ($('.header_keyword_field').text() == "false") {
    $('.header_keyword_check').attr('src', '/assets/fail1.png')
  }
  else if ($('.header_keyword_field').text() == "not_evaluated") {
    $('.header_keyword_check').remove()
    $('.header-keyword-tag').css('margin-left', '30px')
    $('.image-alt-tag').text('[Header Keywords]')
  }
  if ($('.image_field').text() == "false") {
    $('.image_check').attr('src', '/assets/fail1.png')
  }
  else if ($('.image_field').text() == "not_evaluated") {
    $('.image_check').remove()
    $('.image-tag').css('margin-left', '30px')
  }
  if ($('.image_alt_field').text() == "false") {
    $('.image_alt_check').attr('src', '/assets/fail1.png')
  }
  else if ($('.image_alt_field').text() == "not_evaluated") {
    $('.image_alt_check').remove()
    $('.image-alt-tag').css('margin-left', '30px')
    $('.image-alt-tag').text('[Image Alt Descriptions]')
  }
  if ($('.image_alt_keyword_field').text() == "false") {
    $('.image_alt_keyword_check').attr('src', '/assets/fail1.png')
  }
  else if ($('.image_alt_keyword_field').text() == "not_evaluated") {
    $('.image_alt_keyword_check').remove()
    $('.image-alt-keyword-tag').css('margin-left', '30px')
    $('.image-alt-keyword-tag').text('[Image Alt Keywords]')
  }
  if ($('.broken_links_field').text() == "false") {
    $('.broken_links_check').attr('src', '/assets/fail1.png')
  }
  if ($('.content_body_field').text() == "false") {
    $('.content_body_check').attr('src', '/assets/fail1.png')
  }
}


// $('.title_check').remove()
// $('.title-tag').css('margin-left', '30px')
