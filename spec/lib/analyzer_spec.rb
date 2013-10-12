require 'spec_helper'

class MyPage
  attr_accessor :content, :title, :meta
  include Scraper
  include Scraper::Result
end

class MyPageTest
  attr_accessor :page, :test_results
  include Analyzer

  def test_results
    @result ||= {}
  end

end

describe Analyzer do

  let(:page) { MyPage.new }
  before(:each) do
    page.stub(:post) { Nokogiri::HTML(open('spec/factories/dummy_html/dummy_post.html')) }
    page.stub(:article) { Nokogiri::HTML(open('spec/factories/dummy_html/dummy_article.html')) }
    page.stub(:content) { Nokogiri::HTML(open('spec/factories/dummy_html/dummy_article.html')).inner_html }
    page.stub(:title) { "The Power of Equality" }
    page.stub(:original_url) { 'http://editorreverse.tumblr.com/power-of-equality' }
    page.stub(:keyword_with_frequency) { [["equality", 6], ["entrail", 6], ["eagle", 6], ["equity", 6], ["enormity", 6]] }
  end

  let(:page_test) { MyPageTest.new }
  before(:each) do
    page_test.stub(:page) { page }
  end

  describe "keywords in title test" do
    context "with one keyword in the title" do
      
      it "returns the appropriate message" do
        expect(page_test.title_includes_keywords_test).to eq "The keyword \"equality\" appears in your title tag."
      end

      it "passes" do
        page_test.title_includes_keywords_test
        expect(page_test.test_results[:title_keyword_result]).to be true
      end
    end

    context "with zero keywords in the title" do
      before(:each) do
        page.stub(:title) { "The Power of Dog Food" }
      end
      
      it "returns the appropriate message" do
        expect(page_test.title_includes_keywords_test).to eq "None of your keywords occur in your title tag."
      end

      it "fails" do
        page_test.title_includes_keywords_test
        expect(page_test.test_results[:title_keyword_result]).to be false
      end
    end

    context "with more than one keyword in the title" do
      before(:each) do
        page.stub(:title) { "The Equity of Equality" }
      end
     
      it "returns the appropriate message" do
        expect(page_test.title_includes_keywords_test).to eq "Several of your keywords appear in your title tag." 
      end

      it "passes" do
        page_test.title_includes_keywords_test
        expect(page_test.test_results[:title_keyword_result]).to be true
      end
    end
  end

  describe "keywords in url test" do
    context "with one keyword in the url" do
  
      it "returns the appropriate message" do
        expect(page_test.url_includes_keywords_test).to eq "The word \"equality\" appears in your URL."
      end

      it "passes" do
        page_test.url_includes_keywords_test
        expect(page_test.test_results[:url_keyword_result]).to be true
      end
  
    end

    context "with zero keywords in the url" do
      before(:each) do
        page.stub(:original_url) { 'http://www.editorreverse.tumblr.com/nothing-to-see-here' }
      end

      it "returns the appropriate message" do
        expect(page_test.url_includes_keywords_test).to eq "None of your keywords were found in your post's URL."
      end

      it "fails" do
        page_test.url_includes_keywords_test
        expect(page_test.test_results[:url_keyword_result]).to be false
      end
    end

    context "with more than one keyword in the url" do
      before(:each) do
        page.stub(:original_url) { 'http://www.editorreverse.tumblr.com/equity-of-equality' }
      end  

      it "returns the appropriate message" do
        expect(page_test.url_includes_keywords_test).to eq "Several of your keywords were found in your post's URL." 
      end

      it "passes" do
        page_test.url_includes_keywords_test
        expect(page_test.test_results[:url_keyword_result]).to be true
      end
    end
  end

  describe "word count test" do
    context "with less than 300 words" do
      before(:each) do
        page.stub(:article) { Nokogiri::HTML(open('spec/factories/dummy_html/not_enough_words.html')) }
      end

      it "returns the appropriate message" do
        expect(page_test.word_count_test).to eq "Your piece is so short that search engines may not consider it very important."
      end

      it "fails" do
        page_test.word_count_test
        expect(page_test.test_results[:word_count_result]).to be false
      end
    end

    context "with 301-600 words" do
      it "returns the appropriate message" do
        expect(page_test.word_count_test).to eq "This piece falls into a word count range that search engines generally consider to be the optimal length."
      end

      it "passes" do
        page_test.word_count_test
        expect(page_test.test_results[:word_count_result]).to be true
      end
    end

    context "with 601-1000 words" do
      before(:each) do
        page.stub(:article) { Nokogiri::HTML(open('spec/factories/dummy_html/lots_of_words.html')) }
      end

      it "returns the appropriate message" do
        expect(page_test.word_count_test).to eq "Your piece is a bit longer than what is considered optimal for search, although you're still within a reasonable length."
      end

      it "passes" do
        page_test.word_count_test
        expect(page_test.test_results[:word_count_result]).to be true
      end
    end

    context "with over 1000 words" do
      before(:each) do
        page.stub(:article) { Nokogiri::HTML(open('spec/factories/dummy_html/too_many_words.html')) }
      end

      it "returns the appropriate message" do
        expect(page_test.word_count_test).to eq "Your piece is longer than the recommended maximum of 600 words."
      end

      it "fails" do
        page_test.word_count_test
        expect(page_test.test_results[:word_count_result]).to be false
      end
    end
  end

  describe "h1 presence test" do
    context "with too many h1 tags" do  
      before(:each) do
        page.stub(:post) { Nokogiri::HTML(open('spec/factories/dummy_html/too_many_h1s.html')) }
      end

      it "returns the appropriate message" do
        expect(page_test.h1_presence_test).to eq "You have more than one &lt;h1&gt; tag in your post, which may cause search engines to penalize your content."
      end

      it "fails" do
        page_test.h1_presence_test
        expect(page_test.test_results[:h1_presence_result]).to be false
      end
    end

    context "with zero h1 tags" do
      before(:each) do
        page.stub(:post) { Nokogiri::HTML(open('spec/factories/dummy_html/zero_h1s.html')) }
      end

      it "returns the appropriate message" do
        expect(page_test.h1_presence_test).to eq "You don't have any &lt;h1&gt; tags in your piece."
      end

      it "fails" do
        page_test.h1_presence_test
        expect(page_test.test_results[:h1_presence_result]).to be false
      end
    end

    context "with one h1 tag" do
      it "returns the appropriate message" do
        expect(page_test.h1_presence_test).to eq "You have one &lt;h1&gt; tag, which is exactly what search engines want to see."
      end

      it "passes" do
        page_test.h1_presence_test
        expect(page_test.test_results[:h1_presence_result]).to be true
      end
    end
  end

  describe "h1 keywords test" do
    context "with one h1 tag in the post" do
      context "with zero keywords in the h1" do
        before(:each) do
          page.stub(:post) { Nokogiri::HTML(open('spec/factories/dummy_html/zero_keys_in_h1.html')) }
        end

        it "returns the appropriate message" do
          expect(page_test.h1_keywords_test).to eq "None of your keywords are present in your post's &lt;h1&gt; tag."
        end

        it "fails" do
          page_test.h1_keywords_test
          expect(page_test.test_results[:h1_keyword_result]).to be false
        end
      end

      context "with one keyword in the h1" do
        it "returns the appropriate message" do
          expect(page_test.h1_keywords_test).to eq "We found the word \"equality\" in your &lt;h1&gt; tag."
        end
        it "passes" do
          page_test.h1_keywords_test
          expect(page_test.test_results[:h1_keyword_result]).to be true
        end
      end

      context "with several keywords in the h1" do
        before(:each) do
          page.stub(:post) { Nokogiri::HTML(open('spec/factories/dummy_html/lots_of_keys_in_h1.html')) }
        end

        it "returns the appropriate message" do
          expect(page_test.h1_keywords_test).to eq "We found several keywords in your &lt;h1&gt; tag."
        end

        it "passes" do
          page_test.h1_keywords_test
          expect(page_test.test_results[:h1_keyword_result]).to be true
        end
      end
    end

    context "when h1 is missing" do
      before(:each) do
        page.stub(:post) { Nokogiri::HTML(open('spec/factories/dummy_html/zero_h1s.html')) }
      end
      
      it "returns the appropriate message" do
        expect(page_test.h1_keywords_test).to eq "You don't currently have any &lt;h1&gt; tags in your post, so this test did not evaluate. Consider adding an &lt;h1&gt; tag to help search engines and users quickly recognize what your content is about."
      end

      it "does not evaluate" do
        page_test.h1_keywords_test
        expect(page_test.test_results[:h1_keyword_result]).to be :not_evaluated
      end
    end

    context "when there are too many h1s" do
      before(:each) do
        page.stub(:post) { Nokogiri::HTML(open('spec/factories/dummy_html/too_many_h1s.html')) }
      end

      it "returns the appropriate message" do
        expect(page_test.h1_keywords_test).to eq "You have more than one &lt;h1&gt; tag in your post, so this test did not evaluate. Many Tumblr themes place both the title of the blog and the title of the post in &lt;h1&gt; tags. If this is the case for you, consider editing your theme manually."
      end

      it "does not evaluate" do
        page_test.h1_keywords_test
        expect(page_test.test_results[:h1_keyword_result]).to be :not_evaluated
      end
    end
  end

  describe 'alt_tag presence test' do
    context 'when all images have "alt" descriptions' do

      it "returns the appropriate message" do
        expect(page_test.image_alt_tags_presence_test).to eq "Your image tags have 'alt' descriptions."
      end

      it "passes" do
        page_test.image_alt_tags_presence_test
        expect(page_test.test_results[:alt_tags_presence_result]).to be true
      end
    end

    context 'when only some images have "alt" descriptions' do
      before(:each) do
        page.stub(:article) { Nokogiri::HTML(open('spec/factories/dummy_html/images_with_selective_alts.html')) }
      end
      
      it "returns the appropriate message" do
        expect(page_test.image_alt_tags_presence_test).to eq "At least one of your image tags doesn't include an 'alt' description."
      end

      it "fails" do
        page_test.image_alt_tags_presence_test
        expect(page_test.test_results[:alt_tags_presence_result]).to be false
      end
    end

    context 'when no images have "alt" descriptions' do
      before(:each) do
        page.stub(:article) { Nokogiri::HTML(open('spec/factories/dummy_html/images_with_no_alts.html')) }
      end

      it "returns the appropriate message" do
        expect(page_test.image_alt_tags_presence_test).to eq "Your image tags don't currently include 'alt' descriptions."
      end

      it "fails" do
        page_test.image_alt_tags_presence_test
        expect(page_test.test_results[:alt_tags_presence_result]).to be false
      end
    end

    context 'when page has no images' do
      before(:each) do
        page.stub(:article) { Nokogiri::HTML(open('spec/factories/dummy_html/zero_images.html')) }
      end

      it "returns the appropriate message" do
        expect(page_test.image_alt_tags_presence_test).to eq "Your post doesn't have any images, so we could not test them for the presence of 'alt' descriptions."
      end

      it "does not evaluate" do
        page_test.image_alt_tags_presence_test
        expect(page_test.test_results[:alt_tags_presence_result]).to be :not_evaluated
      end
    end
  end 

  describe "image alt tags keywords test" do
    before(:each) do
      page_test.image_alt_tags_presence_test
    end

    context "when the page doesn't have any keywords in its alt descriptions" do
      it "returns the appropriate message" do
        expect(page_test.image_alt_tags_keywords_test).to eq "You are not currently using any of your keywords in your 'alt' descriptions."
      end

      it "fails" do
        page_test.image_alt_tags_keywords_test
        expect(page_test.test_results[:alt_tags_keyword_result]).to be false
      end
    end

    context "when the page has too many keywords in its alt descriptions" do
      before(:each) do
        page.stub(:article) { Nokogiri::HTML(open('spec/factories/dummy_html/alt_tag_keyword_stuffing.html')) }
      end

      it "returns the appropriate message" do
        expect(page_test.image_alt_tags_keywords_test).to eq "Your keywords occur so commonly in your 'alt' descriptions that search engines might think that you're attempting to cheat the system."
      end

      it "fails" do
        page_test.image_alt_tags_keywords_test
        expect(page_test.test_results[:alt_tags_keyword_result]).to be false
      end
    end

    context "when the page has a reasonable number of keywords in its alt descriptions" do
      before(:each) do
        page.stub(:article) { Nokogiri::HTML(open('spec/factories/dummy_html/alt_tag_keyword_on_target.html')) }
      end

      it "returns the appropriate message" do
        expect(page_test.image_alt_tags_keywords_test).to eq "Without overdoing it, you're averaging at least one keyword for each of your 'alt' descriptions."
      end

      it "passes" do
        page_test.image_alt_tags_keywords_test
        expect(page_test.test_results[:alt_tags_keyword_result]).to be true
      end
    end
  end
end
