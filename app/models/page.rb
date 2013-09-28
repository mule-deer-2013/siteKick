require 'rubygems'
require 'nokogiri'
require 'open-uri'

class Page < ActiveRecord::Base

  attr_accessible :content, :original_url

  def get_content
    nokogiri = Nokogiri::HTML(open(self.original_url))
    remove_scripts(nokogiri)
    self.content = nokogiri.inner_html
  end

  def remove_scripts(nokogiri_content)
    nokogiri_content.xpath("//script").remove
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

