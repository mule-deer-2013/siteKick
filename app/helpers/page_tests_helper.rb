module PageTestsHelper

  def keyword_observations
    keywords = @test.keywords
    "#{keywords[0].capitalize}, #{keywords[1]}, #{keywords[2]}, #{keywords[3]}, and #{keywords[4]}."
  end

  def word_count_observations
    "Your piece is approximately #{@page.word_count} words long."
  end

  def join_messages(messages)
    "<ul><li>" + messages.join("</li><li>") + "</li></ul>"
  end

  def title_keywords_messages
    messages = []
    messages << @test.title_includes_keywords_test
    join_messages(messages) + title_why_matters
  end

  def title_keywords_results
    @test.test_results[:title_keyword_result]
  end

  def title_why_matters
    "<span class='why'><strong><u>Why this matters:</u></strong> Your title tag is crucial for letting search engines know what your content is about. It also provides the text that shows up at the top of the browser window.</span>"
  end

  def url_keywords_messages
    messages = []
    messages << @test.url_includes_keywords_test
    join_messages(messages) + url_why_matters
  end

  def url_keywords_results
    @test.test_results[:url_keyword_result]
  end

  def url_why_matters
    "<span class='why'><strong><u>Why this matters:</u></strong> URLs that describe your site content in plain English provide search engines (and users) with more clues about what your post is about.</span>"
  end

  def word_count_messages
    messages = []
    messages << @test.word_count_test
    join_messages(messages) + word_count_why_matters
  end

  def word_count_results
    @test.test_results[:word_count_result]
  end

  def word_count_why_matters
    "<span class='why'><strong><u>Why this matters:</u></strong> Search engines favor content that has between 300 and 600 words.</span>"
  end

  def h1_messages
    messages = []
    messages << @test.h1_presence_test
    join_messages(messages) + header_why_matters
  end

  def h2_messages
  end

  def h3_messages
  end

  def header_results
    @test.test_results[:h1_presence_result]
  end

  def header_keyword_results
    @test.test_results[:h1_keyword_result]
  end

  def h1_keyword_messages
    messages = []
    messages << @test.h1_keywords_test
    join_messages(messages) + header_why_matters
  end

  def header_why_matters
    "<span class='why'><strong><u>Why these matter:</u></strong> Like the title tag, header tags (h1, h2, etc) provide an important cue for search engines about the content of your piece.</span>"
  end

  def image_messages
    messages = []
    messages << @test.number_of_images_test
    join_messages(messages) + image_why_matters
  end

  def image_results
    @test.test_results[:number_of_images_result]
  end

  def image_alt_results
    @test.test_results[:alt_tags_presence_result]
  end

  def image_alt_keyword_results
    @test.test_results[:alt_tags_keyword_result]
  end

  def image_why_matters
    "<span class='why'><strong><u>Why these matter:</u></strong> Images do more than make your page look cool. If you include 'alt' descriptions, they also give search engines further insight into your post.</span>"
  end

  def image_alt_messages
    messages = []
    messages << @test.image_alt_tags_keywords_test
    join_messages(messages) + image_why_matters
  end

  def image_alt_keyword_messages
    messages = []
    messages << @test.image_alt_tags_keywords_test
    join_messages(messages) + image_why_matters
  end

  def broken_links_messages
    messages = []
    messages << @test.broken_links_test
    join_messages(messages) + link_why_matters
  end

  def broken_links_results
    @test.test_results[:broken_links_result]
  end

  def link_why_matters
    "<span class='why'><strong><u>Why these matter:</u></strong> As search engines scan your content, external pages that you link to give them further information about what you're describing. Links to other pages within your site also add to what the engine knows about your site as a whole.</span>"
  end

  def content_body_messages
    messages = []
    messages << @test.keyword_saturation_test
    messages << @test.keywords_in_the_first_150_words_test
    join_messages(messages) + content_body_why_matters
  end
  
  def content_body_results
    @test.test_results[:keyword_saturation_result] && @test.test_results[:keywords_in_the_first_150_words_result]
  end

  def content_body_why_matters
    "<span class='why'><strong><u>Why this matters:</u></strong> The bulk of your content is (or should) be in your &lt;p&gt; tags. Search engines don't place as much emphasis on this area as other tags, but content rich with keywords (particularly toward the beginning of your piece) still influence your search rating.</span>"
  end
end
