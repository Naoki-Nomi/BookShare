class CreatePostBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :post_books do |t|
      t.integer :user_id
      t.integer :genre_id
      t.string :title
      t.text :content
      t.string :post_book_title
      t.string :post_book_author

      t.timestamps
    end
  end
end
