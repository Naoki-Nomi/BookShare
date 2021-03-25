class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :post_book

  def self.favorite_post_book(user_id, page)
    post_book_id = Favorite.where(user_id: user_id).pluck(:post_book_id)
    PostBook.where(id: post_book_id).page(page).reverse_order.includes(:genre, :user, :comments, :favorites)
  end

  def self.after_search_favorite_post_book(user_id, post_books, page)
    post_book_id = Favorite.where(user_id: user_id).pluck(:post_book_id)
    post_books.where(id: post_book_id).page(page).reverse_order.includes(:genre, :user, :comments, :favorites)
  end
end
