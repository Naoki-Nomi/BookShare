class Book < ApplicationRecord

  belongs_to :user
  belongs_to :genre

  # def favorite_author(author)
  #   author.
  # end

end
