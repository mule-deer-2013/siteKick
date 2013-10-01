require 'spec_helper'
require 'ruby-debug'

describe PageTest do

  it { should belong_to :page }
  it { should allow_mass_assignment_of :page_id }
  it { should callback(:run_test_suite).after(:create) }
  it { should serialize(:test_results).as(Hash) }

  let(:page) { FactoryGirl.create(:page) }
  let(:page_test) { FactoryGirl.create(:page_test, page_id: page.id) }

  describe "keywords in title test" do
    context "with one keyword in the title" do
     
      it "returns the appropriate message" do
        expect(page_test.test_results[:title_keyword_output]).to eq "Of these words, we found the word \"equality\" in your title tag. That's a good thing!"
      end

      it "passes" do
        expect(page_test.test_results[:title_keyword_result]).to be true
      end
    end

    context "with zero keywords in the title" do
      let(:page) { FactoryGirl.create(:page, original_url: 'spec/factories/dummy_html/zero_keys_in_title.html') }
      let(:page_test) { FactoryGirl.create(:page_test, page_id: page.id) }
      
      it "returns the appropriate message" do
        expect(page_test.test_results[:title_keyword_output]).to eq "None of the words that occur most often in your post occur in your title tag."
      end

      it "fails" do
        expect(page_test.test_results[:title_keyword_result]).to be false
      end
    end

    context "with more than one keyword in the title" do
      let(:page) { FactoryGirl.create(:page, original_url: 'spec/factories/dummy_html/multiple_keys_in_title.html') }
      let(:page_test) { FactoryGirl.create(:page_test, page_id: page.id) }
     
      it "returns the appropriate message" do
        expect(page_test.test_results[:title_keyword_output]).to eq "We found several of these words in your title tag. Way to go!" 
      end

      it "passes" do
        expect(page_test.test_results[:title_keyword_result]).to be true
      end
    end
  end

  describe "keywords in url test" do
    context "with one keyword in the url" do
      context "without the same keyword in the title" do
        let(:page) { FactoryGirl.create(:page, original_url: 'spec/factories/dummy_html/keyword_board_in_url.html') }
        let(:page_test) { FactoryGirl.create(:page_test, page_id: page.id) }
        it "returns the appropriate message" do
          expect(page_test.test_results[:url_keyword_output]).to eq "We found the word \"board\" in your URL. That's a good thing!"
        end

        it "passes" do
          expect(page_test.test_results[:url_keyword_result]).to be true
        end
      end

      context "with the same keyword in the title" do
        let(:page) { FactoryGirl.create(:page, original_url: 'spec/factories/dummy_html/keyword_equality_in_url.html') }
        let(:page_test) { FactoryGirl.create(:page_test, page_id: page.id) }
        it "returns the appropriate message" do
          expect(page_test.test_results[:url_keyword_output]).to eq "We also found \"equality\" in your page's URL."
        end

        it "passes" do
          expect(page_test.test_results[:url_keyword_result]).to be true
        end
      end
    end

    context "with zero keywords in the url" do
      it "returns the appropriate message" do
        expect(page_test.test_results[:url_keyword_output]).to eq "None of your keywords are present in your post's URL. Customizing your URL to include your keywords could help direct search traffic toward your content."
      end

      it "fails" do
        expect(page_test.test_results[:url_keyword_result]).to be false
      end
    end

    context "with more than one keyword in the url" do
      let(:page) { FactoryGirl.create(:page, original_url: 'spec/factories/dummy_html/keywords_sudoku_board_equality_in_url.html') }
      let(:page_test) { FactoryGirl.create(:page_test, page_id: page.id) }
     
      it "returns the appropriate message" do
        expect(page_test.test_results[:url_keyword_output]).to eq "We found several keywords in your post's URL. Nice work!" 
      end

      it "passes" do
        expect(page_test.test_results[:url_keyword_result]).to be true
      end
    end
  end

  describe "word count test" do
    context "with less than 300 words" do
      let(:page) { FactoryGirl.create(:page, original_url: 'spec/factories/dummy_html/not_enough_words.html') }
      let(:page_test) { FactoryGirl.create(:page_test, page_id: page.id) }

      it "returns the appropriate message" do
        expect(page_test.test_results[:word_count_output]).to eq "Your piece is so short that search engines may not consider it very important. Consider trying to add additional content."
      end

      it "fails" do
        expect(page_test.test_results[:word_count_result]).to be false
      end
    end

    context "with 301-600 words" do
      it "returns the appropriate message" do
        expect(page_test.test_results[:word_count_output]).to eq "In terms of length, this piece is right in the pocket of what search engines are looking for."
      end

      it "passes" do
        expect(page_test.test_results[:word_count_result]).to be true
      end
    end

    context "with 601-1000 words" do
      let(:page) { FactoryGirl.create(:page, original_url: 'spec/factories/dummy_html/lot_of_words.html') }
      let(:page_test) { FactoryGirl.create(:page_test, page_id: page.id) }
      it "returns the appropriate message" do
        expect(page_test.test_results[:word_count_output]).to eq "Your piece is a bit longer than what is considered optimal for search (~600 words). You're still within a reasonable length, but it might be worth keeping an eye on your word count."
      end

      it "passes" do
        expect(page_test.test_results[:word_count_result]).to be true
      end
    end

    context "with over 1000 words" do
      let(:page) { FactoryGirl.create(:page, original_url: 'spec/factories/dummy_html/too_many_words.html') }
      let(:page_test) { FactoryGirl.create(:page_test, page_id: page.id) }
      it "returns the appropriate message" do
        expect(page_test.test_results[:word_count_output]).to eq "Your piece is quite a bit longer than the recommended maximum of 600 words. Consider refocusing on your chosen topic and eliminating unnecessary content."
      end

      it "fails" do
        expect(page_test.test_results[:word_count_result]).to be false
      end
    end
  end

  describe "h1 presence test" do
    context "with too many h1 tags" do  
      let(:page) { FactoryGirl.create(:page, original_url: 'spec/factories/dummy_html/too_many_h1s.html') }
      let(:page_test) { FactoryGirl.create(:page_test, page_id: page.id) }

      it "returns the appropriate message" do
        expect(page_test.test_results[:h1_presence_output]).to eq "You have more than one h1 tag in your post, which may cause search engines to penalize your content."
      end

      it "fails" do
        expect(page_test.test_results[:h1_presence_result]).to be false
      end
    end

    context "with zero h1 tags" do
      let(:page) { FactoryGirl.create(:page, original_url: 'spec/factories/dummy_html/zero_h1s.html') }
      let(:page_test) { FactoryGirl.create(:page_test, page_id: page.id) }

      it "returns the appropriate message" do
        expect(page_test.test_results[:h1_presence_output]).to eq "You don't have any h1 tags in your piece. We strongly advise that you provide a title for your post in an \<h1\> tag."
      end

      it "fails" do
        expect(page_test.test_results[:h1_presence_result]).to be false
      end
    end

    context "with one h1 tag" do
      it "returns the appropriate message" do
        expect(page_test.test_results[:h1_presence_output]).to eq "You have one h1 tag, which is exactly what search engines want to see."
      end

      it "passes" do
        expect(page_test.test_results[:h1_presence_result]).to be true
      end
    end
  end
  
end
