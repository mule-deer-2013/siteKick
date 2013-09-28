class PageTest < ActiveRecord::Base
  attr_accessible :page_id
  belongs_to :page

  serialize :test_results, Hash
  after_create :run_test_suite

  def page
    @page ||= Page.find(self.page_id)
  end

  def run_test_suite
    self.h1_presence_test
    self.save
  end

  def h1_presence_test
    case page.number_of_h1
    when 0
      output = "You have too few h1 tags"
      result = false
    when 1
      output = "You have the right number of h1 tags"
      result = true
    else
      output = "You have too many h1 tags"
      result = false
    end
    self.test_results[:h1_presence_result] = result
    self.test_results[:h1_presence_output] = output
  end

end