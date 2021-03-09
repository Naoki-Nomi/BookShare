class Book < ApplicationRecord

  belongs_to :user
  belongs_to :genre

  validates :author, presence: true
  validates :book_title, presence: true
  validates :read_date, presence: true

  def self.search(user_id, search, genre_id, from, to)
    book = Book
    book = book.where(user_id: user_id) if user_id.present?
    book = book.where("book_title LIKE? OR author LIKE?", "%#{search}%", "%#{search}%") if search.present?
    book = book.where(genre_id: genre_id) if genre_id.present?
    book = book.where(read_date: from..to) if from.present? and to.present?
    book
  end

end
