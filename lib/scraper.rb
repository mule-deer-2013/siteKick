require 'nokogiri'
require 'open-uri'
require 'net/http'
require 'uri'

module Scraper    

  def get_content
    begin
      if !open_url.css('article').inner_html.empty?
        self.content = open_url.css('article').inner_html
        puts "article"  
      elsif open_url.inner_html.match(/post-*\d+/)
        post_id = "#" + open_url.inner_html.match(/post-?\d+/).to_s
        self.content = open_url.css(post_id).inner_html
        post "post-[number]"
      elsif open_url.inner_html.match(/id\s?=\s?['"]post[s]?["']/)
        post_id = "#" + open_url.inner_html.match(/id\s*=\s*['"]post[s]["']*/).to_s.match(/post[s]*/)
        self.content = open_url.css(post_id).inner_html
        puts "post/s"
      elsif open_url.inner_html.match(/id\s?=\s?['"]container["']/)
        post_id = "#container"
        self.content = open_url.css(post_id).inner_html
        puts "container"
      elsif open_url.inner_html.match(/id\s?=\s?['"]blog['"]/)
        post_id = "#blog"
        self.content = open_url.css(post_id).inner_html
        puts "blog"
      end

      self.title = open_url.css('title').text
    rescue

    end
  end

  def open_url
    @content ||= Nokogiri::HTML( open("#{self.original_url}") )
  end

  def remove_scripts(nokogiri_content)
    article_nokogiri_content.xpath("//script").remove
  end

  module Result
    def article_nokogiri
      @article_nokogiri ||= Nokogiri::HTML( self.content )
    end

    def h1_text
      if number_of_h1 < 2
        article_nokogiri.css("h1").text
      else
        article_nokogiri.css("h1").first.text
      end
    end

    def domain
      uri = URI.parse(self.original_url)
      uri.host
    end

    def word_count
      words = article_nokogiri.text
      words.split.length
    end

    def number_of_h1
      article_nokogiri.css("h1").count
    end

    def number_of_h2
      article_nokogiri.css("h2").count
    end

    def number_of_h3
      article_nokogiri.css("h3").count
    end

    def paragraph_text
      article_nokogiri.css("p").text.downcase
    end

    def remove_stop_words
      stop_words = ["0", "a", "about", "above", "after", "again", "against", "all", "am", "an", "and", "any", "are", "aren't", "as", "at", "be", "because", "been", "before", "being", "below", "between", "both", "but", "by", "can't", "cannot", "could", "couldn't", "did", "didn't", "do", "does", "doesn't", "doing", "don't", "down", "during", "each", "few", "for", "from", "further", "had", "hadn't", "has", "hasn't", "have", "haven't", "having", "he", "he'd", "he'll", "he's", "her", "here", "here's", "hers", "herself", "him", "himself", "his", "how", "how's", "i", "i'd", "i'll", "i'm", "i've", "if", "in", "into", "is", "isn't", "it", "it's", "its", "itself", "let's", "me", "more", "most", "mustn't", "my", "myself", "no", "nor", "not", "of", "off", "on", "once", "only", "or", "other", "ought", "our", "ours", "ourselves", "out", "over", "own", "same", "shan't", "she", "she'd", "she'll", "she's", "should", "shouldn't", "so", "some", "such", "than", "that", "that's", "the", "their", "theirs", "them", "themselves", "then", "there", "there's", "these", "they", "they'd", "they'll", "they're", "they've", "this", "those", "through", "to", "too", "under", "until", "up", "very", "was", "wasn't", "we", "we'd", "we'll", "we're", "we've", "were", "weren't", "what", "what's", "when", "when's", "where", "where's", "which", "while", "who", "who's", "whom", "why", "why's", "with", "won't", "would", "wouldn't", "you", "you'd", "you'll", "you're", "you've", "your", "yours", "yourself", "yourselves", "re", 'd', 'll', 'm', 't', 's', 've', 'weren', 'haven', 'aren', 'don', 'shouldn', 'shan', 'mustn']
      array_text = paragraph_text.scan(/\w+/)
      array_text.reject! { |word| word.to_i != 0 || stop_words.include?(word) }
      array_text
    end

    def keyword_with_frequency
      freqs = Hash.new(0)
      remove_stop_words.each { |word| freqs[word] +=1 }
      freqs = freqs.sort_by {|x,y| y }
      freqs.reverse!
      frequent_words_array = freqs.each { |word, freq| word+ ' '+freq.to_s}
      frequent_words_array[0...5]
    end

    def keywords
      keyword_with_frequency.map { |kwf| kwf[0] }
    end

    def number_of_images
      article_nokogiri.css("img").count
    end

    def start_with_text?
      first_word = article_nokogiri.text.split.first
      !content.match(first_word).pre_match.include?("img")
    end

    def image_alt_tags
      article_nokogiri.css('img').map{ |i| i['alt'] }
    end

    def avg_para_length
      paragraphs = article_nokogiri.css("p").map { |para| para.text }
      para_lengths = paragraphs.map { |para| para.length }
      para_lengths.inject(:+)/paragraphs.length
    end

    def text_to_html_ratio
      text_length = article_nokogiri.text.length
      html_length = article_nokogiri.css('html').inner_html.length
      text_length.to_f / html_length.to_f
    end

    def list_of_links
      links = article_nokogiri.css('a').map {|link| link['href']}
    end

    def keyword_saturation(keyword)
      percent = content.scan(/.#{Regexp.escape(keyword)}./).count.to_f / content.split.length
      (percent * 100).round
    end

    # This method does not returning the intended metric. 
    # 'Self-referring links' refers to other pages within the blog—not the same page.
    def self_referring_links
      links = article_nokogiri.css('a').map {|link| link['href']}
      links.select { |link| link.include?(domain) }
    end

    def link_status_messages
      links = article_nokogiri.css('a').map {|link| link['href']} # output => array of string urls
      array_code = links.map do |link|
        url = URI.parse(link)
        res = Net::HTTP.get_response(url)
        until !([301, 302, 303].include?(res.code))
          res = Net::HTTP.get_response(res['location'])
        end
        res.code
      end
    end


  end

end
