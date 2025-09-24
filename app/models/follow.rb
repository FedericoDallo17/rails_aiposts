class Follow < ApplicationRecord
  belongs_to :follower, class_name: 'User'
  belongs_to :following, class_name: 'User'
  
  # Validations
  validates :follower_id, uniqueness: { scope: :following_id }
  validate :cannot_follow_self
  
  # Callbacks
  after_create :create_notification
  after_destroy :destroy_notification
  
  private
  
  def cannot_follow_self
    errors.add(:following, "can't follow yourself") if follower_id == following_id
  end
  
  def create_notification
    Notification.create!(
      user: following,
      title: "New follower",
      content: "#{follower.username} started following you",
      notification_type: "follow"
    )
  end
  
  def destroy_notification
    Notification.where(
      user: following,
      notification_type: "follow",
      content: "#{follower.username} started following you"
    ).destroy_all
  end
end
