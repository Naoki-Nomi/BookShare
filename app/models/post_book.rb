class PostBook < ApplicationRecord

  belongs_to :user
  belongs_to :genre

  has_many :comments, dependent: :destroy

  attachment :post_book_image

end
