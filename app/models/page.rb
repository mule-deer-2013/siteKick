require 'rubygems'
require 'nokogiri'
require 'open-uri'

class Page < ActiveRecord::Base
  attr_accessible :content, :original_url

  def get_content
    url = self.original_url
    nokogiri = Nokogiri::HTML(open(url))
    self.content = nokogiri.inner_html
  end

  def title
    url = self.original_url
    nokogiri = Nokogiri::HTML(open(url))
    nokogiri.at_css("title").text
  end

  def h1
    url = self.original_url
    nokogiri = Nokogiri::HTML(open(url))
    nokogiri.css("h1").text
  end

end
