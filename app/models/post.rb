class Post < ApplicationRecord
  belongs_to :user
  
  # Associations
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liking_users, through: :likes, source: :user
  
  # Validations
  validates :content, presence: true, length: { maximum: 2000 }
  
  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :most_liked, -> { left_joins(:likes).group(:id).order('COUNT(likes.id) DESC') }
  scope :most_commented, -> { left_joins(:comments).group(:id).order('COUNT(comments.id) DESC') }
  scope :recently_commented, -> { joins(:comments).order('comments.created_at DESC') }
  scope :recently_liked, -> { joins(:likes).order('likes.created_at DESC') }
  
  # Methods
  def likes_count
    likes.count
  end
  
  def comments_count
    comments.count
  end
  
  def search_by_content(query)
    where("content ILIKE ?", "%#{query}%")
  end
  
  def search_by_user(user_query)
    joins(:user).where("users.username ILIKE ? OR users.first_name ILIKE ? OR users.last_name ILIKE ?", 
                      "%#{user_query}%", "%#{user_query}%", "%#{user_query}%")
  end
  
  def search_by_tags(tag_query)
    where("tags ILIKE ?", "%#{tag_query}%")
  end
end
