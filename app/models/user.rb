class User < ApplicationRecord
  has_secure_password
  
  # Validations
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :username, presence: true, uniqueness: true, length: { minimum: 3, maximum: 20 }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
  
  # Associations
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post
  has_many :notifications, dependent: :destroy
  
  # Follow associations
  has_many :active_follows, class_name: 'Follow', foreign_key: 'follower_id', dependent: :destroy
  has_many :passive_follows, class_name: 'Follow', foreign_key: 'following_id', dependent: :destroy
  has_many :following, through: :active_follows, source: :following
  has_many :followers, through: :passive_follows, source: :follower
  
  # Active Storage
  has_one_attached :profile_picture
  has_one_attached :cover_picture
  
  # Methods
  def full_name
    "#{first_name} #{last_name}"
  end
  
  def feed_posts
    Post.joins(:user).where(users: { id: following_ids + [id] }).order(created_at: :desc)
  end
  
  def mentioned_posts
    Post.where("content ILIKE ?", "%@#{username}%")
  end
  
  def tagged_posts
    Post.where("tags ILIKE ?", "%#{username}%")
  end
end
