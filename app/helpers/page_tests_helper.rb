module PageTestsHelper

  def keyword_observations
    keywords = @test.keywords
    "#{keywords[0].capitalize}, #{keywords[1]}, #{keywords[2]}, #{keywords[3]}, and #{keywords[4]}."
  end

  def word_count_observations
    "Your piece is approximately #{@page.word_count} words long."
  end

  def join_messages(messages)
    "<p>" + messages.join("</p><p>") + "</p>"
  end

  def title_keywords_messages
    messages = []
    messages << @test.title_includes_keywords_test
    join_messages(messages)
  end

  def title_keywords_results
    @test.test_results[:title_keyword_result]
  end

  def url_keywords_messages
    messages = []
    messages << @test.url_includes_keywords_test
    join_messages(messages)
  end

  def url_keywords_results
    @test.test_results[:url_keyword_result]
  end

  def word_count_messages
    messages = []
    messages << @test.word_count_test
    join_messages(messages)
  end

  def word_count_results
    @test.test_results[:word_count_result]
  end

  def h1_messages
    messages = []
    messages << @test.h1_presence_test
    messages << @test.h1_keywords_test
    join_messages(messages)
  end

  def h2_messages
  end

  def h3_messages
  end

  def header_results
    @test.test_results[:h1_presence_result] && @test.test_results[:h1_keyword_result]
  end

  def image_messages
    messages = []
    messages << @test.number_of_images_test
    messages << @test.image_alt_tags_presence_test
    messages << @test.image_alt_tags_keywords_test
    join_messages(messages)
  end

  def image_results
    @test.test_results[:number_of_images_result] &&
    @test.test_results[:alt_tags_presence_result] &&
    @test.test_results[:alt_tags_keyword_result]
  end

  def content_body_messages
    messages = []
    messages << @test.keyword_saturation_test
    messages << @test.keywords_in_the_first_150_words_test
    join_messages(messages)
  end
  
  def content_body_results
    @test.test_results[:keyword_saturation_result] && @test.test_results[:keywords_in_the_first_150_words_result]
  end

  def link_messages
  end

  def link_results
    true
  end

end
