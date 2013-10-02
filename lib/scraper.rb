require 'nokogiri'
require 'open-uri'
require 'net/http'
require 'uri'
require 'ruby-debug'

module Scraper    

  def get_content
    if !open_url.css('article').inner_html.empty?
      self.content = open_url.css('article').inner_html  
    else
      post_id = "#" + open_url.inner_html.match(/post-\d+/).to_s
      self.content = open_url.css(post_id).inner_html
    end

    self.title = open_url.css('title').text
    self.meta = open_url.css('meta').text
  end

  def open_url
    @content ||= Nokogiri::HTML( open("#{self.original_url}") )
  end

  module Result
    def article_nokogiri
      @article_nokogiri ||= Nokogiri::HTML( self.content )
    end

    def remove_scripts(nokogiri_content)
      article_nokogiri_content.xpath("//script").remove
    end

    def h1_text
      if number_of_h1 < 2
        article_nokogiri.css("h1").text
      else
        article_nokogiri.css("h1").first.text
      end
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
      links.select { |link| link.include?(original_url) }
    end

  # TO DO: Discuss negative tests with team. Wordpress and Tumblr
  # seem to have built-in redirects??
    def broken_links_due_syntax
      links = article_nokogiri.css('a').map {|link| link['href']} # output => array of string urls
      broken_syntax_links = []
      links.each do |link|
        url = URI.parse(link)
        url.kind_of?(URI::HTTP) || url.kind_of?(URI::HTTPS)
        broken_syntax_links << url if false
      end
      broken_syntax_links
    end



    def broken_links_code
      links = article_nokogiri.css('a').map {|link| link['href']} # output => array of string urls
      array_code = links.map do |link|
        url = URI.parse(link)
        req = Net::HTTP::Get.new(url.path)
        res = Net::HTTP.start(url.host, url.port) {|http|http.request(req)}
        res.code
      end
       #Output: array with code response for each link ex.200

      # PENDING --->
           # - Need to add Queuing Jobs(Call Back): https://github.com/collectiveidea/delayed_job
      handle_asynchronously :delivery
    end


  end

end
