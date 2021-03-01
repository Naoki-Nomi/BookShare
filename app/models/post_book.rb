class PostBook < ApplicationRecord

  belongs_to :user
  belongs_to :genre

  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  attachment :post_book_image

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

end
