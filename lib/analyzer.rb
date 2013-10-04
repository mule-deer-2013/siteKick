module Analyzer

  def keywords
    @keywords ||= page.keyword_with_frequency.map { |word_and_freq| word_and_freq[0] }
  end

  def run_test_suite
    self.title_includes_keywords_test
    self.url_includes_keywords_test
    self.word_count_test
    self.h1_presence_test
    self.h1_keywords_test
    self.number_of_images_test
    self.image_alt_tags_presence_test
    self.image_alt_tags_keywords_test
    self.broken_links_test
    self.keyword_saturation_test
    self.keywords_in_the_first_150_words_test
    self.save
  end

  def number_of_tests_passed
    passed = []
    self.test_results.each_value do |value|
      passed << value if value == true
    end
    passed.length
  end

  def number_of_tests_evaluated
    evaluated = []
    self.test_results.each_value do |value|
      evaluated << value if value == true || value == false
    end
    evaluated.length
  end

  ### "MAIN_MESSAGES" TESTS ###

  def title_includes_keywords_test
    @keywords_in_title = keywords.select {|word| page.title.downcase.include?(word) }

    case @keywords_in_title.length
    when 0
      output = "None of your keywords occur in your title tag."
      result = false
    when 1
      output = "The keyword \"#{@keywords_in_title[0]}\" appears in your title tag."
      result = true
    else
      output = "Several of your keywords appear in your title tag."
      result = true
    end

    self.test_results[:title_keyword_result] = result
    output
  end

  def url_includes_keywords_test
    @keywords_in_url = keywords.select {|word| page.original_url.downcase.match(word) }

    case @keywords_in_url.length
    when 0
      output = "None of your keywords were found in your post's URL."
      result = false
    when 1
      output = "The word \"#{@keywords_in_url[0]}\" appears in your URL."
      result = true
    else
      output = "Several of your keywords were found in your post's URL."
      result = true
    end

    self.test_results[:url_keyword_result] = result
    output
  end

  def word_count_test
    case page.word_count
    when 0..300
      output = "Your piece is so short that search engines may not consider it very important."
      result = false
    when 301..600
      output = "This piece falls into a word count range that search engines generally consider to be the optimal length."
      result = true
    when 601..1000
      output = "Your piece is a bit longer than what is considered optimal for search, although you're still within a reasonable length."
      result = true
    else
      output = "Your piece is longer than the recommended maximum of 600 words."
      result = false
    end

    self.test_results[:word_count_result] = result
    output
  end

  ### HEADER-TAG TESTS ###

  def h1_presence_test
    case page.number_of_h1
    when 0
      output = "You don't have any &lt;h1&gt; tags in your piece."
      result = false
    when 1
      output = "You have one &lt;h1&gt; tag, which is exactly what search engines want to see."
      result = true
    else
      output = "You have more than one &lt;h1&gt; tag in your post, which may cause search engines to penalize your content."
      result = false
    end
    self.test_results[:h1_presence_result] = result
    output
  end

  def h1_keywords_test
    if page.number_of_h1 > 0
      keywords_in_h1 = keywords.select {|word| page.h1_text.downcase.match(word) }
      case keywords_in_h1.length
      when 0
        output = "None of your keywords are present in your post's &lt;h1&gt; tag."
        result = false
      when 1    
        output = "We found the word \"#{keywords_in_h1[0]}\" in your &lt;h1&gt; tag."  
        result = true
      else
        output = "We found several keywords in your &lt;h1&gt; tag."
        result = true
      end
    else
      output = "You don't currently have any &lt;h1&gt; tags in your post, so this test did not evaluate. Consider adding an &lt;h1&gt; tag to help search engines and users quickly recognize what your content is about."
      result = :not_evaluated
    end

    self.test_results[:h1_keyword_result] = result
    output
  end

  ### P TESTS ###

  def keyword_saturation_test
    oversaturated = []
    underrepresented = []
    page.keywords.each do |keyword|
      percent = page.keyword_saturation(keyword)
      case percent
      when 0
        underrepresented << keyword
      when 4..100
        oversaturated = []
      end
    end 
    if oversaturated.length == 0
      if underrepresented.length == 0
        result = true
        output = "Each of your keywords occupies between 1 and 3% of your content, which is considered optimal by most search engines."
      elsif underrepresented.length > 0 && underrepresented.length < 3
        result = true
        output = "Most of your keywords occupy between 1 and 3% of your content, which is considered optimal by most search engines."
      else
        result = false
        output = "Most of your keywords occupy less than 1% of your content. Consider ways that you might build additional mentions of those words into your headers, meta tags, links, and image tags."
      end
    elsif oversaturated.length == 1
      result = false
      output = "You've mentioned the word #{oversaturated.first} so many times that it now makes up #{percent}% of your piece. Search engines may penalize sites if they feel they're using keywords to game the system."
    else
      result = false
      output = "Several of your keywords are making up 4% or more of your total html content, which might lead search engines to believe that you're trying to game the system."
    end

    self.test_results[:keyword_saturation_result] = result
    output
  end

  def keywords_in_the_first_150_words_test
    first_150 = page.content.split.shift(150)
    first_keys = first_150.select {|word| keywords.include?(word) }
    case first_keys.length
    when 0
      result = false
      output = "We didn't find a single keyword in the first 150 words of your piece."
    when 1
      result = false
      output = "We only found one keyword in the first 150 words of your piece."
    when 2
      result = false
      output = "We only found two keywords in the first 150 words of your piece."
    when 3..10
      result = true
      output = "We found a handful of keywords in the first 150 words of your piece."
    else
      result = true
      output = "You have plenty of keywords in the first 150 words of your piece."
    end

    self.test_results[:keywords_in_the_first_150_words_result] = result
    output
  end

  ### IMG TESTS ###

  def number_of_images_test
    case page.number_of_images
    when 0
      result = true
      output = "Your content body doesn't contain any images. This shouldn't affect what search engines think about your content."
    when 1
      result = true
      output = "Your post contains one image. This shouldn't affect what search engines think about your content."
    when 2..4
      result = true
      output = "Your post contains #{page.number_of_images} images. This shouldn't affect what search engines think about your content."
    else
      result = false
      output = "Your post has more than four images, which might lead some search engines to believe that your content is of low quality."
    end

    self.test_results[:number_of_images_result] = result
    output
  end

  def image_alt_tags_presence_test
    if page.number_of_images > 0
      if page.image_alt_tags.include?(nil)
        if page.image_alt_tags.reject { |tag| tag.nil? }.empty?
          result = false
          output = "Your image tags don't currently include 'alt' descriptions."
        else
          result = false
          output = "At least one of your image tags doesn't include an 'alt' description."
        end
      else
        result = true
        output = "Your image tags have 'alt' descriptions."
      end
    else
      result = :not_evaluated
      output = "Your post doesn't have any images, so we could not test them for the presence of 'alt' descriptions."
    end
    self.test_results[:alt_tags_presence_result] = result
    output
  end

  def image_alt_tags_keywords_test
    if page.number_of_images > 0 
      if self.test_results[:alt_tags_presence_result] == true
        keywords_in_alt_tags = []

        page.image_alt_tags.each do |tag|
          tag.split.each do |word|
            if keywords.include?(word.downcase)
              keywords_in_alt_tags << word
            end
          end
        end

        if keywords_in_alt_tags.count > (3 * page.number_of_images)
          result = false
          output = "Your keywords occur so commonly in your 'alt' descriptions that search engines might think that you're attempting to cheat the system."
        elsif keywords_in_alt_tags.count == 0
          result = false
          output = "You are not currently using any of your keywords in your 'alt' descriptions."
        elsif keywords_in_alt_tags.count < (1 * page.number_of_images)
          result = false
          output = "You are not using many of your keywords in your 'alt' descriptions."
        else
          result = true
          output = "Without overdoing it, you're averaging at least one keyword for each of your 'alt' descriptions."
        end
      else
        result = :not_evaluated
        output = "At least some of the images in your post are missing 'alt' descriptions, so we did not evaluate them for the presence of keywords."
      end
    else
      result = :not_evaluated
      output = "Your post does not have any images, so we could not test the content of their 'alt' descriptions."
    end
    self.test_results[:alt_tags_keyword_result] = result
    output
  end

  ### LINK TESTS ###

  def broken_links_test
    begin
      page.link_status_messages.each do |status|
        if (400..499).include?(status.to_i)
          self.test_results[:broken_links_result] = false
          return "Your page has broken links."
        end
      end
      self.test_results[:broken_links_result] = true
      "Your page does not have any broken links."
    rescue
      self.test_results[:broken_links_result] = :not_evaluated
      "Due to the unique structure of your blog, we were unable to evaluate your links. Sorry!"
    end
  end
end
