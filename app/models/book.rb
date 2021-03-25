class Book < ApplicationRecord
  belongs_to :user
  belongs_to :genre

  validates :author, presence: true, length: { maximum: 30 }
  validates :book_title, presence: true, length: { maximum: 30 }
  validates :read_date, presence: true
  validates :note, length: { maximum: 1200 }

  # 検索時の処理（ユーザーIDは特定のユーザーの読書に限定する際に使用）
  def self.search(user_id, search, genre_id, from, to)
    book = Book
    book = book.where(user_id: user_id) if user_id.present?
    book = book.where("book_title LIKE? OR author LIKE?", "%#{search}%", "%#{search}%") if search.present?
    book = book.where(genre_id: genre_id) if genre_id.present?
    book = book.where(read_date: from..to) if from.present?
    book
  end

  def self.book_index(user_id, page)
    Book.where(user_id: user_id).page(page).order(read_date: "DESC").includes(:genre)
  end

  def self.genre_for_graph(user_id)
    Book.where(user_id: user_id).joins(:genre).group("genres.name").count
  end

  def self.week_read_book(user_id)
    Book.where(user_id: user_id).group_by_week(:read_date).count
  end

  def self.year_read_book(user_id)
    Book.where(user_id: user_id).group_by_year(:read_date).count
  end

  def self.month_read_book(user_id)
    Book.where(user_id: user_id).group_by_month(:read_date).count
  end

  def self.author_number(user_id, author_number)
    Book.where(user_id: user_id).group(:author).order('count_all DESC').limit(author_number).count
  end
end
