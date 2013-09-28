# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

class PageImporter

  def self.create_pages
    page = Page.new(original_url: 'http://www.editorreverse.tumblr.com')
    page.save
    page.content = "<h1>Here's an h1</h1><h1>Here's another h1</h1><h1>Here's a third h1</h1>"
    page.save 
  end 

end

PageImporter.create_pages 