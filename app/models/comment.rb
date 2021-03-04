class Comment < ApplicationRecord

  belongs_to :user
  belongs_to :post_book
  
  has_many :notifications, dependent: :destroy

end