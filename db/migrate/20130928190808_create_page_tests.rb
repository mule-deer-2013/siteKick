class CreatePageTests < ActiveRecord::Migration
  def change
    create_table :page_tests do |t|
      t.belongs_to :page
      t.text :test_results
    end
  end
end
