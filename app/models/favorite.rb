class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :post_book

  def self.favorite_post_book(user_id)
    favorites = Favorite.where(user_id: user_id)
    post_book_id = favorites.pluck(:post_book_id)
    post_book_id
  end
end
