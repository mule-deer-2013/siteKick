FactoryGirl.define do

  factory :page do
    original_url 'spec/factories/dummy_html/dummy_post.html'
  end

  factory :page_test do
    page
  end

end
