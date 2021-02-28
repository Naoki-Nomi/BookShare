class PostBook < ApplicationRecord

  belongs_to :user
  belongs_to :genre

  attachment :post_book_image

end
