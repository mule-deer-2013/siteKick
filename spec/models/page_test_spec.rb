require 'spec_helper'
require 'ruby-debug'
class MyPageTest
  include Analyzer
end

describe PageTest do

  it { should belong_to :page }
  it { should allow_mass_assignment_of :page_id }
  it { should callback(:run_test_suite).after(:create) }
  it { should serialize(:test_results).as(Hash) }

end
