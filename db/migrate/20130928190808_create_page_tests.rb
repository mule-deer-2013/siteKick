class CreatePageTests < ActiveRecord::Migration
  def change
    create_table :page_tests do |t|
      t.belongs_to :page
      t.string :h1_presence_output 
      t.boolean :h1_presence_result
    end
  end
end
