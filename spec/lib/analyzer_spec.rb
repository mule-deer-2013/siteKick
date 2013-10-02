require 'spec_helper'

class MyPage
  attr_accessor :content, :title, :meta
  include Analyzer
end

describe Analyzer do

  let(:page) { FactoryGirl.create(:page) }
  let(:page_test) { FactoryGirl.create(:page_test, page_id: page.id) }

  describe "keywords in title test" do
    context "with one keyword in the title" do
     
      it "returns the appropriate message" do
        expect(page_test.title_includes_keywords_test).to eq "Of these words, we found the word \"equality\" in your title tag. That's a good thing!"
      end

      it "passes" do
        expect(page_test.test_results[:title_keyword_result]).to be true
      end
    end

    context "with zero keywords in the title" do
      let(:page) { FactoryGirl.create(:page, original_url: 'spec/factories/dummy_html/zero_keys_in_title.html') }
      let(:page_test) { FactoryGirl.create(:page_test, page_id: page.id) }
      
      it "returns the appropriate message" do
        expect(page_test.title_includes_keywords_test).to eq "None of the words that occur most often in your post occur in your title tag."
      end

      it "fails" do
        expect(page_test.test_results[:title_keyword_result]).to be false
      end
    end

    context "with more than one keyword in the title" do
      let(:page) { FactoryGirl.create(:page, original_url: 'spec/factories/dummy_html/multiple_keys_in_title.html') }
      let(:page_test) { FactoryGirl.create(:page_test, page_id: page.id) }
     
      it "returns the appropriate message" do
        expect(page_test.title_includes_keywords_test).to eq "We found several of these words in your title tag. Way to go!" 
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
          expect(page_test.url_includes_keywords_test).to eq "We found the word \"board\" in your URL. That's a good thing!"
        end

        it "passes" do
          expect(page_test.test_results[:url_keyword_result]).to be true
        end
      end

      context "with the same keyword in the title" do
        let(:page) { FactoryGirl.create(:page, original_url: 'spec/factories/dummy_html/keyword_equality_in_url.html') }
        let(:page_test) { FactoryGirl.create(:page_test, page_id: page.id) }
        it "returns the appropriate message" do
          expect(page_test.url_includes_keywords_test).to eq "We also found \"equality\" in your page's URL."
        end

        it "passes" do
          expect(page_test.test_results[:url_keyword_result]).to be true
        end
      end
    end

    context "with zero keywords in the url" do
      it "returns the appropriate message" do
        expect(page_test.url_includes_keywords_test).to eq "None of your keywords are present in your post's URL. Customizing your URL to include your keywords could help direct search traffic toward your content."
      end

      it "fails" do
        expect(page_test.test_results[:url_keyword_result]).to be false
      end
    end

    context "with more than one keyword in the url" do
      let(:page) { FactoryGirl.create(:page, original_url: 'spec/factories/dummy_html/keywords_sudoku_board_equality_in_url.html') }
      let(:page_test) { FactoryGirl.create(:page_test, page_id: page.id) }
     
      it "returns the appropriate message" do
        expect(page_test.url_includes_keywords_test).to eq "We found several keywords in your post's URL. Nice work!" 
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
        expect(page_test.word_count_test).to eq "Your piece is so short that search engines may not consider it very important. Consider trying to add additional content."
      end

      it "fails" do
        expect(page_test.test_results[:word_count_result]).to be false
      end
    end

    context "with 301-600 words" do
      it "returns the appropriate message" do
        expect(page_test.word_count_test).to eq "In terms of length, this piece is right in the pocket of what search engines are looking for."
      end

      it "passes" do
        expect(page_test.test_results[:word_count_result]).to be true
      end
    end

    context "with 601-1000 words" do
      let(:page) { FactoryGirl.create(:page, original_url: 'spec/factories/dummy_html/lot_of_words.html') }
      let(:page_test) { FactoryGirl.create(:page_test, page_id: page.id) }
      it "returns the appropriate message" do
        expect(page_test.word_count_test).to eq "Your piece is a bit longer than what is considered optimal for search (~600 words). You're still within a reasonable length, but it might be worth keeping an eye on your word count."
      end

      it "passes" do
        expect(page_test.test_results[:word_count_result]).to be true
      end
    end

    context "with over 1000 words" do
      let(:page) { FactoryGirl.create(:page, original_url: 'spec/factories/dummy_html/too_many_words.html') }
      let(:page_test) { FactoryGirl.create(:page_test, page_id: page.id) }
      it "returns the appropriate message" do
        expect(page_test.word_count_test).to eq "Your piece is quite a bit longer than the recommended maximum of 600 words. Consider refocusing on your chosen topic and eliminating unnecessary content."
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
        expect(page_test.h1_presence_test).to eq "You have more than one h1 tag in your post, which may cause search engines to penalize your content."
      end

      it "fails" do
        expect(page_test.test_results[:h1_presence_result]).to be false
      end
    end

    context "with zero h1 tags" do
      let(:page) { FactoryGirl.create(:page, original_url: 'spec/factories/dummy_html/zero_h1s.html') }
      let(:page_test) { FactoryGirl.create(:page_test, page_id: page.id) }

      it "returns the appropriate message" do
        expect(page_test.h1_presence_test).to eq "You don't have any h1 tags in your piece. We strongly advise that you provide a title for your post in an \<h1\> tag."
      end

      it "fails" do
        expect(page_test.test_results[:h1_presence_result]).to be false
      end
    end

    context "with one h1 tag" do
      it "returns the appropriate message" do
        expect(page_test.h1_presence_test).to eq "You have one h1 tag, which is exactly what search engines want to see."
      end

      it "passes" do
        expect(page_test.test_results[:h1_presence_result]).to be true
      end
    end
  end

  describe "h1 keywords test" do

    context "with zero keywords in the first h1" do
      let(:page) { FactoryGirl.create(:page, original_url: 'spec/factories/dummy_html/zero_keys_in_h1.html') }
      let(:page_test) { FactoryGirl.create(:page_test, page_id: page.id) }

      it "returns the appropriate message" do
        expect(page_test.h1_keywords_test).to eq "None of your keywords are present in your post's h1 tag. Customizing your h1 to include your keywords could help direct search traffic toward your content."
      end
      it "fails" do
        expect(page_test.test_results[:h1_keyword_result]).to be false
      end
    end

    context "with one keyword in the first h1" do
      it "returns the appropriate message" do
        expect(page_test.h1_keywords_test).to eq "We found the word \"equality\" in your h1 tag. That's a good thing!"
      end
      it "passes" do
        expect(page_test.test_results[:h1_keyword_result]).to be true
      end
    end

    context "with several keywords in the first h1" do
      let(:page) { FactoryGirl.create(:page, original_url: 'spec/factories/dummy_html/lots_of_keys_in_h1.html') }
      let(:page_test) { FactoryGirl.create(:page_test, page_id: page.id) }

      it "returns the appropriate message" do
        expect(page_test.h1_keywords_test).to eq "We found several keywords in your h1 tag. Nice work!"
      end
      it "passes" do
        expect(page_test.test_results[:h1_keyword_result]).to be true
      end
    end

    context "when h1 is missing" do
      let(:page) { FactoryGirl.create(:page, original_url: 'spec/factories/dummy_html/zero_h1s.html') }
      let(:page_test) { FactoryGirl.create(:page_test, page_id: page.id) }
      
      it "returns the appropriate message" do
        expect(page_test.h1_keywords_test).to eq "An h1 tag is an excellent opportunity to show search engines what your piece is about. Add one to the top of your piece and use one or more keywords to send a strong message about your content."
      end
      it "fails" do
        expect(page_test.test_results[:h1_keyword_result]).to be false
      end
    end
  end 

  describe 'alt_tag presence test' do
    context 'when all images have "alt" descriptions' do

      it "returns the appropriate message" do
        expect(page_test.image_alt_tags_presence_test).to eq "Your image tags have 'alt' descriptions."
      end

      it "passes" do
        expect(page_test.test_results[:alt_tags_presence_result]).to be true
      end
    end

    context 'when only some images have "alt" descriptions' do
      let(:page) { FactoryGirl.create(:page, original_url: 'spec/factories/dummy_html/images_with_selective_alts.html') }
      let(:page_test) { FactoryGirl.create(:page_test, page_id: page.id) }

      it "returns the appropriate message" do
        expect(page_test.image_alt_tags_presence_test).to eq "At least one of your image tags doesn't include an 'alt' description. When used responsibly, these descriptions are an excellent way to tell search engines what your page is about."
      end

      it "fails" do
        expect(page_test.test_results[:alt_tags_presence_result]).to be false
      end
    end

    context 'when no images have "alt" descriptions' do
      let(:page) { FactoryGirl.create(:page, original_url: 'spec/factories/dummy_html/images_with_no_alts.html') }
      let(:page_test) { FactoryGirl.create(:page_test, page_id: page.id) }

      it "returns the appropriate message" do
        expect(page_test.image_alt_tags_presence_test).to eq "Your image tags don't currently include 'alt' descriptions. When used responsibly, these descriptions are an excellent way to tell search engines what your page is about."
      end

      it "fails" do
        expect(page_test.test_results[:alt_tags_presence_result]).to be false
      end
    end

    context 'when page has no images' do
      let(:page) { FactoryGirl.create(:page, original_url: 'spec/factories/dummy_html/zero_images.html') }
      let(:page_test) { FactoryGirl.create(:page_test, page_id: page.id) }

      it "returns the appropriate message" do
        expect(page_test.image_alt_tags_presence_test).to eq "Images offer you an opportunity to share more information with search engines about what your content is about (and hopefully help to make your page look cool) but if you don't want them in your content, don't worry about it!"
      end

      it "passes" do
        expect(page_test.test_results[:alt_tags_presence_result]).to be true
      end
    end
  end 

  describe "image alt tags keywords test" do
    context "when the page doesn't have any keywords in its alt descriptions" do
      it "returns the appropriate message" do
        expect(page_test.image_alt_tags_keywords_test).to eq "You are not currently using any of your keywords in your 'alt' descriptions, which is a missed opportunity to help tell search engines what your page is about."
      end

      it "fails" do
        expect(page_test.test_results[:alt_tags_keyword_result]).to be false
      end
    end

    context "when the page has too many keywords in its alt descriptions" do
      let(:page) { FactoryGirl.create(:page, original_url: 'spec/factories/dummy_html/alt_tag_keyword_stuffing.html') }
      let(:page_test) { FactoryGirl.create(:page_test, page_id: page.id) }

      it "returns the appropriate message" do
        expect(page_test.image_alt_tags_keywords_test).to eq "Your keywords occur so commonly in your 'alt' descriptions that search engines might think that you're attempting to cheat the system. In order to avoid being penalized, examine your 'alt' descriptions and consider dialing back on your keyword usage."
      end

      it "fails" do
        expect(page_test.test_results[:alt_tags_keyword_result]).to be false
      end
    end

    context "when the page has a reasonable number of keywords in its alt descriptions" do
      let(:page) { FactoryGirl.create(:page, original_url: 'spec/factories/dummy_html/alt_tag_keyword_on_target.html') }
      let(:page_test) { FactoryGirl.create(:page_test, page_id: page.id) }

      it "returns the appropriate message" do
        expect(page_test.image_alt_tags_keywords_test).to eq "Without overdoing it, you're averaging at least one keyword for each of your 'alt' descriptions. That's right where you want your images to be."
      end

      it "passes" do
        expect(page_test.test_results[:alt_tags_keyword_result]).to be true
      end
    end
  end
end
