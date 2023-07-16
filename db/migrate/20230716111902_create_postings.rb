class CreatePostings < ActiveRecord::Migration[7.0]
  def change
    create_table :postings do |t|
      t.text :title
      t.text :content
      t.string :slug
      t.timestamps
    end
  end
end
