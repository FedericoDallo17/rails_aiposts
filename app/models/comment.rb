class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  
  # Validations
  validates :content, presence: true, length: { maximum: 500 }
  
  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  
  # Callbacks
  after_create :create_notification
  
  private
  
  def create_notification
    return if user_id == post.user_id # Don't notify the post author about their own comment
    
    Notification.create!(
      user: post.user,
      title: "New comment",
      content: "#{user.username} commented on your post",
      notification_type: "comment"
    )
  end
end
