module PageTestsHelper

  def keyword_observations
    keywords = @test.keywords
    "The five most common keywords found in your piece were #{keywords[0]}, #{keywords[1]}, #{keywords[2]}, #{keywords[3]}, and #{keywords[4]}."
  end

  def word_count_observations
    "Your piece is approximately #{@page.word_count} words long."
  end

  def join_messages(messages)
    "<p>" + messages.join("</p><p>") + "</p>"
  end

  def title_keywords_messages
    messages = []
    messages << keyword_observations
    messages << @test.title_includes_keywords_test
    join_messages(messages)
  end

  def url_keywords_messages
    messages = []
    messages << keyword_observations
    messages << @test.url_includes_keywords_test
    join_messages(messages)
  end

  def word_count_messages
    messages = []
    messages << word_count_observations
    messages << @test.word_count_test
    join_messages(messages)
  end

  def h1_messages
    messages = []
    messages << @test.h1_presence_test
    if @page.number_of_h1 == 1
      messages << keyword_observations
      messages << @test.h1_keywords_test
    end
    join_messages(messages)
  end

  def h2_messages
  end

  def h3_messages
  end

  def image_messages
  end

  def paragraph_messages
  end

  def link_messages
  end

end
