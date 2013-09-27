require 'spec_helper'

describe Page do 

  let(:page) { FactoryGirl.create(:page) }

  describe '#get_content' do
    it "parses html content" do
      nokogiri = Nokogiri::HTML(File.open("Google.html"))
      expect(page.get_content).to eql nokogiri.inner_html
    end
  end

end