require 'spec_helper'

describe PageTest do

  it { should belong_to :page}
  it { should allow_mass_assignment_of :page_id }
  it { should callback(:run_test_suite).after(:create)}
  it { should serialize(:test_results).as(Hash)}

end


# describe Page_Test do

  # let(:page_test_results) { :test_results =>
  #                     { h1_presence_result: true,
  #                       h1_presence_output: "You have the right number of h1 tags",
  #                       title_keyword_result: true,
  #                       title_keyword_output: "Here are the most common words in your post: #{keywords}. We found several of these words in your title tag. Way to go!"
  #                      }
  #                  }

  # let(:page) { id: 2, content: "content", original_url: "https://www.google.com/" }


  # describe '#page' do
  #   it "finds the page" do
  #     expect(:page).to eql Page.find(2)
  #   end
  # end