class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.text :content
      t.text :original_url
      t.text :title
      t.text :meta
      t.timestamps
    end
  end
end
