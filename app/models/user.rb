class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  attachment :profile_image

  enum is_deleted: { 有効: false, 退会済み: true }

  validates :nickname, presence: true, uniqueness: true, length: { minimum: 2, maximum: 10 }
  validates :introduction, length: { maximum: 400 }
  validates :email, presence: true

  has_many :post_books, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :books, dependent: :destroy

  has_many :follower, class_name: "Relationship", foreign_key: 'follower_id', dependent: :destroy
  has_many :followed, class_name: "Relationship", foreign_key: 'followed_id', dependent: :destroy

  has_many :following_users, through: :follower, source: :followed
  has_many :follower_users, through: :followed, source: :follower

  has_many :active_notifications, class_name: "Notification", foreign_key: 'visitor_id', dependent: :destroy
  has_many :passive_notifications, class_name: "Notification", foreign_key: 'visited_id', dependent: :destroy

  def follow(user_id)
    follower.create(followed_id: user_id)
  end

  def unfollow(user_id)
    follower.find_by(followed_id: user_id).destroy
  end

  def following?(user)
    following_users.include?(user)
  end

  # フォローの通知を作成
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

  def get_following_users(page)
    following_users.page(page).includes(:post_books, :books, :following_users, :follower_users)
  end

  def get_follower_users(page)
    follower_users.page(page).includes(:post_books, :books, :following_users, :follower_users)
  end

  # フォロー中のユーザーをニックネームから検索
  def get_search_following_users(nickname, page)
    following_users.where("nickname Like?", "%#{nickname}%").page(page).includes(:post_books, :books, :following_users, :follower_users)
  end

  # フォロワーのユーザーをニックネームから検索
  def get_search_follower_users(nickname, page)
    follower_users.where("nickname Like?", "%#{nickname}%").page(page).includes(:post_books, :books, :following_users, :follower_users)
  end
end
