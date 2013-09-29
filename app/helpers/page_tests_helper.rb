module PageTestsHelper

  def main_messages
    @test.test_results[:title_keyword_output]
  end

  def h1_messages
    @test.test_results[:h1_presence_output]
  end
  
end