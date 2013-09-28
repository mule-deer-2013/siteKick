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
    word = (nokogiri.css("h1").count)
  end


  def number_of_h2
    word = (nokogiri.css("h2").count)/2
  end

  def number_of_h3
    word = (nokogiri.css("h3").count)/2
  end


  # def brainstorming_evaluate_words_on_page
  #   @most_common_words = []
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

