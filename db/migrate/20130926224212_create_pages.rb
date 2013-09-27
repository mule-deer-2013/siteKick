class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.text :content
      t.text :original_url
      t.timestamps
    end
  end
end
