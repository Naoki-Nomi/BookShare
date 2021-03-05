class PostBook < ApplicationRecord

  belongs_to :user
  belongs_to :genre

  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  has_many :notifications, dependent: :destroy

  attachment :post_book_image

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  def create_notification_favorite(current_user)
    temp = Notification.where(["visitor_id = ? and visited_id = ? and post_book_id = ? and action = ?", current_user.id, user_id, id, 'favorite'])
    if temp.blank?
      notification = current_user.active_notifications.new(
        post_book_id: id,
        visited_id: user_id,
        action: 'favorite'
        )
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save
    end
  end

  def create_notification_comment(current_user, comment_id)
    notification = current_user.active_notifications.new(
      post_book_id: id,
      comment_id: comment_id,
      visited_id: user_id,
      action: 'comment'
      )
    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save
  end

  def self.search(user_id, search, genre_id)
      post_book = PostBook
      post_book = post_book.where(user_id: user_id) if user_id.present?
      post_book = post_book.where("title LIKE? OR post_book_author LIKE? OR post_book_title LIKE?", "%#{search}%", "%#{search}%", "%#{search}%") if search.present?
      post_book = post_book.where(genre_id: genre_id) if genre_id.present?
      post_book
  end

end