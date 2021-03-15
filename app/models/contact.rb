class Contact < ApplicationRecord
  validates :name, presence: true, length: { maximum: 30 }
  validates :email, presence: true
  validates :content, presence: true, length: { maximum: 400 }
end
