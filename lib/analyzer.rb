require 'ruby-debug'

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
    self.keyword_saturation_test
    self.keywords_in_the_first_150_words_test
    self.number_of_images_test
    self.image_alt_tags_presence_test
    self.image_alt_tags_keywords_test
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
    self.test_results.length
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
    output
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
    output
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
    output
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
    output
  end

  def h1_keywords_test
    if page.number_of_h1 > 0
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
    else
      output = "An h1 tag is an excellent opportunity to show search engines what your piece is about. Add one to the top of your piece and use one or more keywords to send a strong message about your content."
      result = false
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
        output = "Each of your keywords occupies between 1 and 3% of your body text, which is perfect."
      elsif underrepresented.length > 0 && underrepresented.length < 3
        result = true
        output = "Most of your keywords occupy between 1 and 3% of your body text, which is really strong."
      else
        result = false
        output = "Most of your keywords occupy less than 1% of your body text, which is less than ideal. Consider ways that you might build additional mentions of those words into your headers, meta tags, links, and image tags."
      end
    elsif oversaturated.length == 1
      result = false
      output = "You've mentioned the word #{oversaturated.first} so many times that it now makes up #{percent}% of your piece. Search engines may penalize sites if they feel they're using keywords to game the system."
    else
      result = false
      output = "Several of your keywords are making up 4% or more of your total html content, which might lead search engines to believe that you're trying to game the system. Consider editing yourself."
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
      output = "We didn't find a single keyword in the first 150 words of your piece. Placing important words toward the beginning of your piece helps search engines know what your post is about."
    when 1
      result = false
      output = "We only found one keyword in the first 150 words of your piece. Placing important words toward the beginning of your piece helps search engines know what your post is about."
    when 2
      result = false
      output = "We only found two keywords in the first 150 words of your piece. Placing important words toward the beginning of your piece helps search engines know what your post is about."
    when 3..10
      result = true
      output = "We found a handful of keywords in the first 150 words of your piece, which is great. Search engines often place greater emphasis on this area when trying to figure out what sites are about."
    else
      result = true
      output = "You have a ton of keywords in the first 150 words of your piece, which is fantastic and should help search engines to know exactly what you're talking about."
    end

    self.test_results[:keywords_in_the_first_150_words_result] = result
    output
  end

  ### IMG TESTS ###

  def number_of_images_test
    case page.number_of_images
    when 0
      result = true
      output = "Your content body doesn't contain any images."
    when 1
      result = true
      output = "One image"
    when 2..4
      result = true
      output = "2-4 images"
    else
      result = false
      output = "Five or more images"
    end

    self.test_results[:number_of_images_result] = result
    output
  end

  def image_alt_tags_presence_test
    if page.number_of_images == 0
      result = true
      output = "Images offer you an opportunity to share more information with search engines about what your content is about (and hopefully help to make your page look cool) but if you don't want them in your content, don't worry about it!"
    else
      if page.image_alt_tags.include?(nil)
        if page.image_alt_tags.reject { |tag| tag.nil? }.empty?
          result = false
          output = "Your image tags don't currently include 'alt' descriptions. When used responsibly, these descriptions are an excellent way to tell search engines what your page is about."
        else
          result = false
          output = "At least one of your image tags doesn't include an 'alt' description. When used responsibly, these descriptions are an excellent way to tell search engines what your page is about."
        end
      else
        result = true
        output = "Your image tags have 'alt' descriptions."
      end
    end

    self.test_results[:alt_tags_presence_result] = result
    output
  end

  def image_alt_tags_keywords_test
    if page.number_of_images > 0 && self.test_results[:alt_tags_presence_result] == true
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
        output = "Your keywords occur so commonly in your 'alt' descriptions that search engines might think that you're attempting to cheat the system. In order to avoid being penalized, examine your 'alt' descriptions and consider dialing back on your keyword usage."
      elsif keywords_in_alt_tags.count == 0
        result = false
        output = "You are not currently using any of your keywords in your 'alt' descriptions, which is a missed opportunity to help tell search engines what your page is about."
      elsif keywords_in_alt_tags.count < (1 * page.number_of_images)
        result = false
        output = "You are not currently using many of your keywords in your 'alt' descriptions, which is a missed opportunity to help tell search engines what your page is about."
      else
        result = true
        output = "Without overdoing it, you're averaging at least one keyword for each of your 'alt' descriptions. That's right where you want your images to be."
      end
    end

    self.test_results[:alt_tags_keyword_result] = result
    output
  end

  ### LINK TESTS ###

end
