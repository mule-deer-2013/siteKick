require 'spec_helper'
require 'ruby-debug'

class MyPage
  attr_accessor :content, :title, :meta, :user_id
  include Scraper
  include Scraper::Result
end


describe Scraper::Result do

  let(:page) { MyPage.new }
  before(:each) do 
    page.stub(:post) { Nokogiri::HTML(open('spec/factories/dummy_html/dummy_post.html')) }
    page.stub(:article) { Nokogiri::HTML(open('spec/factories/dummy_html/dummy_article.html')) }
    page.stub(:content) { Nokogiri::HTML(open('spec/factories/dummy_html/dummy_article.html')).inner_html }
  end

  context "#h1_text" do
    context "with a single h1 tag" do
      it "returns the text of an h1 tag" do
        expect(page.h1_text).to eq ["The Power of Equality"]
      end
    end
    context "with multiple h1 tags" do
      it "returns the text of the first h1 tag" do
        page.stub(:post) { Nokogiri::HTML(open('spec/factories/dummy_html/too_many_h1s.html')) }
        expect(page.h1_text).to eq ["The Power of Wishful Thinking", "The Power of Equality", "The Power of Equality"]
      end
    end
    context "with zero h1 tags" do
      it "returns an empty array" do
        page.stub(:post) { Nokogiri::HTML(open('spec/factories/dummy_html/zero_h1s.html')) }
        expect(page.h1_text).to eq []
      end
    end
  end

  context "#word_count" do
    it "returns the word count of the article body" do
      expect(page.word_count).to be 533
    end
  end

  context "#number_of_h1" do
    it "returns the number of h1 tags in the post" do
      expect(page.number_of_h1).to be 1
    end
  end

  context "#remove_stop_words" do
    it "returns an array of strings" do
      expect(page.remove_stop_words).to be_an_instance_of Array
      expect(page.remove_stop_words.first).to be_an_instance_of String
    end

    it "filters common words from the article body" do
      expect(page.remove_stop_words).not_to include('the')
    end 
  end

  context "#keyword_with_frequency" do
    it "returns a nested array of words and their frequencies" do
      expect(page.keyword_with_frequency.first).to eq ['board', 6]
    end
  end

  context "#number_of_body_images" do
    it "returns the number of image tags on the page" do
      expect(page.number_of_body_images).to be 1
    end
  end

  context "#start_with_text?" do
    context "when the page starts with an image" do
      it "returns false" do
        expect(page.start_with_text?).to be false
      end
    end

    context "when the page starts with text" do
      it "returns true" do
        page.stub(:content) { "An awesome piece of html that <img></img> doesn't start with an image."}
        expect(page.start_with_text?).to be true
      end
    end
  end

  context "#image_alt_tags" do
    context "when the page contains multiple images" do
      it "should return an array of alt tags from images" do
        page.stub(:article) { Nokogiri::HTML(open('spec/factories/dummy_html/multiple_images.html')) }
        expect(page.image_alt_tags).to eq ["image1", "image2", "image3"]
      end
    end

    context "when the page contains a single image" do
      it "should return a single-item array" do
        expect(page.image_alt_tags).to eq ["image"]
      end
    end

    context "when images don't have alt tags" do
      it "should return nil for images that don't have them" do
        page.stub(:article) { Nokogiri::HTML(open('spec/factories/dummy_html/images_with_selective_alts.html')) }
        expect(page.image_alt_tags).to eq [nil, "image2", nil]
      end
    end
  end

  context "#avg_para_length" do
    it "should return the average length of all text paragraphs" do
      expect(page.avg_para_length).to be 286
    end
  end

  context "#text_to_html_ratio" do
    it "should return the ratio of text characters to html characters" do
      expect((page.text_to_html_ratio * 100000).to_i).to be 80296
    end
  end

  context "#list_of_links" do
    it "should return a list of all links found on the page" do
      expect((page.list_of_links).length).to eq 2
      expect((page.list_of_links).first).to eq "#"
    end
  end
end
