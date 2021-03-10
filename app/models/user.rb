class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  attachment :profile_image

  enum is_deleted: { 有効: false, 退会済み: true }

  validates :nickname, presence: true, uniqueness: true, length: { maximum: 10 } # ニックネームは一意性
  validates :email, presence: true

  has_many :post_books, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :books, dependent: :destroy

  has_many :follower, class_name: "Relationship", foreign_key: 'follower_id', dependent: :destroy
  has_many :followed, class_name: "Relationship", foreign_key: 'followed_id', dependent: :destroy

  has_many :following_user, through: :follower, source: :followed
  has_many :follower_user, through: :followed, source: :follower

  has_many :active_notifications, class_name: "Notification", foreign_key: 'visitor_id', dependent: :destroy
  has_many :passive_notifications, class_name: "Notification", foreign_key: 'visited_id', dependent: :destroy

  def follow(user_id)
    follower.create(followed_id: user_id)
  end

  def unfollow(user_id)
    follower.find_by(followed_id: user_id).destroy
  end

  def following?(user)
    following_user.include?(user)
  end

  def create_notification_follow(current_user)
    temp = Notification.where(["visitor_id = ? and visited_id = ? and action = ?", current_user.id, id, "follow"])
    if temp.blank?
      notification = current_user.active_notifications.new(
        visited_id: id,
        action: 'follow'
      )
      notification.save
    end
  end
end
