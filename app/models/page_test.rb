class PageTest < ActiveRecord::Base
  attr_accessible :page_id
  belongs_to :page

  serialize :test_results, Hash
  after_create :run_test_suite

  include Analyzer

  def run_test_suite
    self.title_includes_keywords_test
    self.url_includes_keywords_test
    self.word_count_test
    self.h1_presence_test
    self.h1_keywords_test
    self.save
  end

end
