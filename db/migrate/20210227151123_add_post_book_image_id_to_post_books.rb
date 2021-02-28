class AddPostBookImageIdToPostBooks < ActiveRecord::Migration[5.2]
  def change
    add_column :post_books, :post_book_image_id, :string
  end
end
