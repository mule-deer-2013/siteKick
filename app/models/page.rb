class Page < ActiveRecord::Base
  include Scraper
  include Scraper::Result
  
  attr_accessible :content, :original_url, :title, :user_id
  before_create :get_title, :get_content

end




