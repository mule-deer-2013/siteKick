$(function() {

  function toggleOverlay(element) {
    var highlighted = element.hasClass("highlighted");
    var previouslySelected = $(".highlighted");
    if (previouslySelected.length === 0){
        $('.highlighted').css({
          position: 'static',
          zIndex: 0,
          "background-color": ""
        });
      $('.overlay').remove();
    }
    var applicable = element.parent().hasClass('post_data');
    //first half before the or simply checkes to see if the tags have changed.  If it has changed remove the highlight
    //the second half says don't remove the highlight for these types of html elements
    if ( applicable || (previouslySelected.length > 0 && element[0].tagName != previouslySelected[0].tagName) || (element[0].tagName != "A" && element[0].tagName != "P" && element[0].tagName != "IMG") ){
      $('.highlighted').css({
          position: 'static',
          zIndex: 0,
          "background-color": ""
        });
      $('.overlay').remove();
      previouslySelected.removeClass("highlighted");
    }
    if (!highlighted) {
      element.css({
        position: 'relative',
        zIndex  : 20,
        "background-color": "#fff"
      });

      var w = $('.article_content').width();
      var h = $('.article_content').height();
      var t = $('.article_content').position().top;
      var l = $('.article_content').position().left;
      var $overlay = $('<div/>', {
        'class': 'overlay',
        css: {
          position   : 'absolute',
          height     : h + 25 +'px',
          width      : w + 25 +'px',
          left       : l + 'px',
          top        : t + 'px',
          background : '#000',
          opacity    : 0.5,
          zIndex     : 10
        }
      }).appendTo('.article_content');
      element.addClass("highlighted");
    } else {
      $('.highlighted').css({
        position: 'static',
        zIndex: 0,
        "background-color": ""
      });
      $('.overlay').remove();
      element.css('background-color', 'transparent');
      element.removeClass("highlighted");
    }
  }

  $('.title-tag').on('click', function(){toggleOverlay($("#title"));});
  $('.url-tag').on('click', function(){toggleOverlay($("#url"));});
  $('.word-tag').on('click', function(){toggleOverlay($("#word"));});
  $('.header-tag').on('click',function(){
    $.each($('.original-article h1'), function(){
      toggleOverlay($(this).addClass('hi'));
    });
  });

  $('.image-tag').on('click',function(){
    $.each($('.original-article img'), function(){
      toggleOverlay($(this));
    });
  });

  $('.link-tag').on('click',function(){
    $.each($('.original-article a'), function(){
      toggleOverlay($(this));
    });
  });

  $('.content-tag').on('click',function(){
    $.each($('.original-article p'), function(){
      toggleOverlay($(this));
    });
  });



});
