class PageTest < ActiveRecord::Base
  attr_accessible :page_id
  belongs_to :page

  serialize :test_results, Hash
  after_create :run_test_suite

  def keywords
    @keywords ||= page.keyword_frequency.map { |word_and_freq| word_and_freq[0] }
  end

  ### "MAIN_MESSAGES" TESTS ###

  def title_includes_keywords_test
    @keywords_in_title = keywords.select {|word| page.title.downcase.include?(word) }

    case @keywords_in_title.length
    when 0
      output = "None of the words that occur most often in your post occur in your title tag."
      result = false
    when 1
      output = "Of these words, we found the word \"#{@keywords_in_title[0]}\" in your title tag. That's a good thing!"
      result = true
    else
      output = "We found several of these words in your title tag. Way to go!"
      result = true
    end

    self.test_results[:title_keyword_result] = result
    self.test_results[:title_keyword_output] = output
  end

  def url_includes_keywords_test
    @keywords_in_url = keywords.select {|word| page.original_url.downcase.match(word) }

    case @keywords_in_url.length
    when 0
      output = "None of your keywords are present in your post's URL. Customizing your URL to include your keywords could help direct search traffic toward your content."
      result = false
    when 1
      if @keywords_in_url[0] == @keywords_in_title[0]
        output = "We also found \"#{@keywords_in_url[0]}\" in your page's URL."
      else
        output = "We found the word \"#{@keywords_in_url[0]}\" in your URL. That's a good thing!"
      end
      result = true
    else
      output = "We found several keywords in your post's URL. Nice work!"
      result = true
    end

    self.test_results[:url_keyword_result] = result
    self.test_results[:url_keyword_output] = output
  end

  def word_count_test
    case page.word_count
    when 0..300
      output = "Your piece is so short that search engines may not consider it very important. Consider trying to add additional content."
      result = false
    when 301..600
      output = "In terms of length, this piece is right in the pocket of what search engines are looking for."
      result = true
    when 601..1000
      output = "Your piece is a bit longer than what is considered optimal for search (~600 words). You're still within a reasonable length, but it might be worth keeping an eye on your word count."
      result = true
    else
      output = "Your piece is quite a bit longer than the recommended maximum of 600 words. Consider refocusing on your chosen topic and eliminating unnecessary content."
      result = false
    end

    self.test_results[:word_count_result] = result
    self.test_results[:word_count_output] = output
  end

  ### HEADER-TAG TESTS ###

  def h1_presence_test
    case page.number_of_h1
    when 0
      output = "You don't have any h1 tags in your piece. We strongly advise that you provide a title for your post in an \<h1\> tag."
      result = false
    when 1
      output = "You have one h1 tag, which is exactly what search engines want to see."
      result = true
    else
      output = "You have more than one h1 tag in your post, which may cause search engines to penalize your content."
      result = false
    end
    self.test_results[:h1_presence_result] = result
    self.test_results[:h1_presence_output] = output
  end

  def h1_keywords_test
    if page.number_of_h1 == 1
      keywords_in_h1 = keywords.select {|word| page.h1_text.downcase.match(word) }
      case keywords_in_h1.length
      when 0
        output = "None of your keywords are present in your post's h1 tag. Customizing your h1 to include your keywords could help direct search traffic toward your content."
        result = false
      when 1    
        output = "We found the word \"#{keywords_in_h1[0]}\" in your h1 tag. That's a good thing!"  
        result = true
      else
        output = "We found several keywords in your h1 tag. Nice work!"
        result = true
      end

      self.test_results[:h1_keyword_result] = result
      self.test_results[:h1_keyword_output] = output
    end
  end

  ### P TESTS ###

  def keyword_saturation_test
    percentage = page.remove_stop_words.select { |word| self.keywords.include?(word) }.length / page.word_count.to_f
    return percentage
    # This isn't quite what keyword saturation is (yet). We'd need to include things like plurals, etc.
    # I'm also not quite sure how to test keyword saturation for five words at a time. Sort of a weird metric.
  end

  ### IMG TESTS ###

  ### LINK TESTS ###

  def run_test_suite
    self.title_includes_keywords_test
    self.url_includes_keywords_test
    self.word_count_test
    self.h1_presence_test
    self.h1_keywords_test
    self.save
  end

end
