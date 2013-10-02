class Page < ActiveRecord::Base
  include Scraper
  include Scraper::Result
  attr_accessible :content, :original_url, :title
  before_create :get_content

end



