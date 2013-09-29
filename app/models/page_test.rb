class PageTest < ActiveRecord::Base
  attr_accessible :page_id
  belongs_to :page

  serialize :test_results, Hash
  after_create :run_test_suite

  def page
    @page ||= Page.find(self.page_id)
  end

  def title_includes_keywords_test
    keywords_in_title = keywords.select {|word| page.title.include?(word) }

    case keywords_in_title.length
    when 0
      output = "None of the words that occur most often in your post occur in your title tag."
      result = false
    when 1
      output = "Of these words, we found the word #{keywords_in_title[0]} in your title tag. That's a good thing!"
      result = true
    else
      output = "We found several of these words in your title tag. Way to go!"
      result = true
    end

    self.test_results[:title_keyword_result] = result
    self.test_results[:title_keyword_output] = self.keyword_statement + output
  end

  def keywords
    @keywords ||= page.keyword_frequency.map { |word_and_freq| word_and_freq[0] }
  end

  def keyword_statement
    "Here are the most common words in your post: #{keywords}."
  end

  def h1_presence_test
    case page.number_of_h1
    when 0
      output = "You have too few h1 tags"
      result = false
    when 1
      output = "You have the right number of h1 tags"
      result = true
    else
      output = "You have too many h1 tags"
      result = false
    end
    self.test_results[:h1_presence_result] = result
    self.test_results[:h1_presence_output] = output
  end

  def run_test_suite
    self.h1_presence_test
    self.title_includes_keywords_test
    self.save
  end

end