$(function() {

  function toggleOverlay(selector) {

    var $toHighlight = $(selector);
    // 1. If the passed-in selector is already highlighted, that means
    //    the user clicked the same one twice, so let's just uni=highlight.
    var justTurnOff = $toHighlight.hasClass('highlighted');

    // 2. Find any elements that are already highlighted, and unhighlight them.
    $('.highlighted').removeClass('highlighted');

    // 3. Remove any existing overlays.
    $('.overlay').remove();

    if (!justTurnOff) {
      // 4. Highlight the passed-in element.
      $toHighlight.addClass('highlighted');

      // 5. Add the overlay on top of the article.
      getOverlay().appendTo('.article_content');
    }
  }

  function getOverlay() {
    var w = $('.article_content').width();
    var h = $('.article_content').height();
    var t = $('.article_content').position().top;
    var l = $('.article_content').position().left;
    var $overlay = $('<div/>', {
      'class': 'overlay',
      css: {
        width  : w+30 + 'px',
      }
    });
    return $overlay;
  }

  // We want to highlight the header tag when keywords is clicked.
  $('.original-article h1').addClass('keywords');

  $('.title-tag').on('click', function() { toggleOverlay(".title"); });
  $('.url-tag').on('click', function() { toggleOverlay(".url"); });
  $('.word-tag').on('click', function() { toggleOverlay(".word"); });
  $('.header-keyword-tag').on('click', function() { toggleOverlay(".keywords"); });

  $('.header-tag').on('click',function() { toggleOverlay('.original-article h1'); });
  $('.image-tag').on('click',function() { toggleOverlay('.original-article img'); });
  $('.link-tag').on('click',function() { toggleOverlay('.original-article a'); });
  $('.content-tag').on('click',function() { toggleOverlay('.original-article section'); });
});
