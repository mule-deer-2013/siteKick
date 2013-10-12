require 'nokogiri'
require 'open-uri'
require 'net/http'
require 'uri'

module Scraper    

  def get_content
    @user = User.find(self.user_id)
    @posts = @user.tumblr_client.posts("#{@user.uid}.tumblr.com")['posts']
    @posts.each do |post|
      if post["post_url"] == self.original_url
        self.content = post["body"]
      end
    end
  end

  def get_title
    self.title = post.css('title').text
  end

  module Result
    def article
      @article ||= Nokogiri::HTML( self.content )
    end

    def post
      @post ||= Nokogiri::HTML(open(self.original_url))
    end

    def h1_text
      post.css("h1").map { |h1| h1.text }
    end

    def h1_text_display
      h1_text.join(", ")
    end

    def domain
      uri = URI.parse(self.original_url)
      uri.host
    end

    def word_count
      words = article.text
      words.split.length
    end

    def number_of_h1
      post.css("h1").count
    end

    def paragraph_text
      article.css("p").text.downcase
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

    def number_of_body_images
      article.css("img").count
    end

    def start_with_text?
      first_word = article.text.split.first
      !content.match(first_word).pre_match.include?("img")
    end

    def image_alt_tags
      article.css('img').map{ |i| i['alt'] }
    end

    def avg_para_length
      paragraphs = article.css("p").map { |para| para.text }
      para_lengths = paragraphs.map { |para| para.length }
      para_lengths.inject(:+)/paragraphs.length
    end

    def text_to_html_ratio
      text_length = article.text.length
      html_length = article.css('html').inner_html.length
      text_length.to_f / html_length.to_f
    end

    def list_of_links
      links = article.css('a').map {|link| link['href']}
    end

    def keyword_saturation(keyword)
      percent = content.scan(/.#{Regexp.escape(keyword)}./).count.to_f / content.split.length
      (percent * 100).round
    end

    def self_referring_links
      links = article.css('a').map {|link| link['href']}
      links.select { |link| link.include?(domain) }
    end

    def link_status_messages
      links = article.css('a').map {|link| link['href']} # output => array of string urls
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
