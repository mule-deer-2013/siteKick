require 'rubygems'
require 'nokogiri'
require 'open-uri'

class Page < ActiveRecord::Base

  attr_accessible :content, :original_url

  before_create :get_content


  def get_content
    url = self.original_url
    self.content = Nokogiri::HTML( open(url) ).css('article').inner_html
    save if !new_record?  #Temporal: Please keep it because it helps me when we call it in the console 
  end

  def nokogiri
    @nokogiri ||= Nokogiri::HTML( content ) # .tap do |obj|
      # Rails.logger.debug( "**** Nokogiri: #{obj.inspect}" )  # debug in rails (.tap...)
    # end

  end

  def remove_scripts(nokogiri_content)
    nokogiri_content.xpath("//script").remove
  end

  def title
    nokogiri.css("title").text
  end

  def h1_text
    nokogiri.css("h1").text
  end

  def word_count #400-600?
    word = nokogiri.css("p").text
    array_words = word.split
    array_words.length  #aprox based on p tags
  end

   def number_of_h1

   nokogiri.css("h1").count

  end


  def number_of_h2
    nokogiri.css("h2").count
  end

  def number_of_h3
    nokogiri.css("h3").count
  end

  def remove_stop_words

    text = nokogiri.css("p").text.downcase!

    array_text = text.scan(/\w+/)

    stop_words = ["0", "a", "about", "above", "after", "again", "against", "all", "am", "an", "and", "any", "are", "aren't", "as", "at", "be", "because", "been", "before", "being", "below", "between", "both", "but", "by", "can't", "cannot", "could", "couldn't", "did", "didn't", "do", "does", "doesn't", "doing", "don't", "down", "during", "each", "few", "for", "from", "further", "had", "hadn't", "has", "hasn't", "have", "haven't", "having", "he", "he'd", "he'll", "he's", "her", "here", "here's", "hers", "herself", "him", "himself", "his", "how", "how's", "i", "i'd", "i'll", "i'm", "i've", "if", "in", "into", "is", "isn't", "it", "it's", "its", "itself", "let's", "me", "more", "most", "mustn't", "my", "myself", "no", "nor", "not", "of", "off", "on", "once", "only", "or", "other", "ought", "our", "ours", "ourselves", "out", "over", "own", "same", "shan't", "she", "she'd", "she'll", "she's", "should", "shouldn't", "so", "some", "such", "than", "that", "that's", "the", "their", "theirs", "them", "themselves", "then", "there", "there's", "these", "they", "they'd", "they'll", "they're", "they've", "this", "those", "through", "to", "too", "under", "until", "up", "very", "was", "wasn't", "we", "we'd", "we'll", "we're", "we've", "were", "weren't", "what", "what's", "when", "when's", "where", "where's", "which", "while", "who", "who's", "whom", "why", "why's", "with", "won't", "would", "wouldn't", "you", "you'd", "you'll", "you're", "you've", "your", "yours", "yourself", "yourselves", "re", 'd', 'll', 'm', 't', 's', 've', 'weren', 'haven', 'aren', 'don', 'shouldn', 'shan', 'mustn'] 

    array_text.reject! { |word| word.to_i != 0 }
    array_text.reject! { |word| stop_words.include?(word) }
    array_text
  end

  def keyword_frequency
    clean_text = remove_stop_words
    freqs = Hash.new(0)
    clean_text.each { |word| freqs[word] +=1 }
    freqs = freqs.sort_by {|x,y| y }
    freqs.reverse!
    frequent_words_array =freqs.each { |word, freq| word+ ' '+freq.to_s}
    frequent_words_array[0...5]
  end
  # def brainstorming_evaluate_words_on_page
  #   @number_of_header_tags
  #   @self_referring_links
  #   @broken_links
  #   @outgoing_links
  #   @font_size_for_p_tags
  #   @avg_paragraph_length
  #   @keywords_in_url
  #   @title_length
  #   @keywords_in_meta_description
  #   @meta_description_length
  #   @meta_title
  #   @keyword_density #percentage of keywords on page
  #   @keyword_variations
  #   @starts_with_text?
  #   @number_of_images
  #   @h1_and_h2_and_h3?
  #   @number_of_h1s
  #   @keywords_in_headings
  #   @alt_text_in_images?
  #   @text_versus_html #25-70% text
  #   @page_load_speed #?

  # end


  




end

