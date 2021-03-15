class Genre < ApplicationRecord
  has_many :post_books, dependent: :destroy
  has_many :books, dependent: :destroy

  validates :name, presence: true
end
