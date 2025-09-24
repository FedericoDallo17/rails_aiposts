class Notification < ApplicationRecord
  belongs_to :user
  
  # Validations
  validates :title, presence: true
  validates :content, presence: true
  validates :notification_type, presence: true
  
  # Scopes
  scope :unread, -> { where(read: false) }
  scope :read, -> { where(read: true) }
  scope :by_type, ->(type) { where(notification_type: type) }
  scope :recent, -> { order(created_at: :desc) }
  
  # Methods
  def mark_as_read!
    update!(read: true)
  end
  
  def mark_as_unread!
    update!(read: false)
  end
end
