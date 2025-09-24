class Like < ApplicationRecord
  belongs_to :user
  belongs_to :post
  
  # Validations
  validates :user_id, uniqueness: { scope: :post_id }
  
  # Callbacks
  after_create :create_notification
  after_destroy :destroy_notification
  
  private
  
  def create_notification
    return if user_id == post.user_id # Don't notify the post author about their own like
    
    Notification.create!(
      user: post.user,
      title: "New like",
      content: "#{user.username} liked your post",
      notification_type: "like"
    )
  end
  
  def destroy_notification
    Notification.where(
      user: post.user,
      notification_type: "like",
      content: "#{user.username} liked your post"
    ).destroy_all
  end
end
