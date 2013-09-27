require 'spec_helper'

describe Page do 

  describe '#get_content' do
    it "parses html content" do
      nokogiri = Nokogiri::HTML(File.open("Google.html"))
      expect(Page.create(content: "content", original_url: "Google.html").get_content).to eql nokogiri.inner_html
    end
  end

end