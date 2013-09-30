require 'spec_helper'

describe Page do 

  let(:page) { FactoryGirl.create(:page) }

  describe '#get_content' do
    it "parses html content" do
      page.get_content
      expect(page.title).to eq "Google"
    end
  end

  describe '#article_nokogiri' do
    it "" do
      
      #I don't get what this method is doing.

    end
  end

  describe '#h1_text' do
    it "selects the text inside h1 tags" do
      expect(page.h1_text).to eq ''
    end
  end

  describe '#word_count' do
    it "counts words inside p tags" do
      expect(page.word_count).to eq 0
    end
  end

  describe '#number_of_h1' do
    it "checks the number of h1 tags" do
      expect(page.number_of_h1).to eq 0 
    end
  end

  describe 'number_of_h2' do
    it "checks the number of h2 tags" do
      expect(page.number_of_h2).to eq 0
    end
  end

  describe 'number_of_h3' do
    it "checks the number of h3 tags" do
      expect(page.number_of_h3).to eq 0
    end
  end


end