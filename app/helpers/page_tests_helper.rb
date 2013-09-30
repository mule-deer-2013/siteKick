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

  def main_messages
    messages = []
    messages << keyword_observations
    messages << @test.test_results[:title_keyword_output]
    messages << @test.test_results[:url_keyword_output]
    messages << word_count_observations
    messages << @test.test_results[:word_count_output]
    "<h2><u>General Observations</u></h2>" + join_messages(messages)
  end

  def h1_messages
    messages = []
    messages << @test.test_results[:h1_presence_output]
    if @page.number_of_h1 == 1
      messages << keyword_observations
      messages << @test.test_results[:h1_keyword_output]
    end
    "<h2><u>Header Observations</u></h2>" + join_messages(messages)
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