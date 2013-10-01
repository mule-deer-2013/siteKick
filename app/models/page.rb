class Page < ActiveRecord::Base
  include Scraper
  include Scraper::Result
  attr_accessible :content, :original_url, :title
  before_create :get_content

end

    #Message for Testing (Dan):
      # if (200..307).to_a.include?(code)
      #   "Good Link"
      # else
      #   "Broken Link due to unable to reach the website or server error" #(400's and 500's errors)
      # end


  #Dan (within test):
  #   @keywords_in_url                                  #DONE
  #   @keywords_in_meta_description
  #   @meta_description_length
  #   @meta_title
  #   @keyword_density #percentage of keywords on page
  #   @keywords_in_headings                             #DONE

  #Optional:
  #   @font_size_for_p_tags
  #   @page_load_speed #?

  #TO BE DISCUSSED:
  #   @keyword_variations



