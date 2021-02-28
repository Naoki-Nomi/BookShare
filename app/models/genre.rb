class Genre < ApplicationRecord

  has_many :post_books, dependent: :destroy

end
