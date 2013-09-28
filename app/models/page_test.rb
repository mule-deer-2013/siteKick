class PageTest < ActiveRecord::Base
  attr_accessible :page_id, :h1_presence_test, :h1_presence_output
  belongs_to :page

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
      output = "You don't have any h1 tags. They're important."
      result = false
    when 1
      output = "You have the correct number of h1 tags."
      result = true
    else
      output = "You have too many h1 tags."
      result = false
    end
    self.h1_presence_result = result
    self.h1_presence_output = output
  end

end