class NotificationJob < ApplicationJob
  queue_as :default
  
  def perform(notification_type, user_id, data)
    case notification_type
    when 'email_digest'
      send_email_digest(user_id, data)
    when 'push_notification'
      send_push_notification(user_id, data)
    when 'sms'
      send_sms(user_id, data)
    end
  end
  
  private
  
  def send_email_digest(user_id, data)
    user = User.find(user_id)
    # In a real app, you would send an email here
    Rails.logger.info "Sending email digest to #{user.email}"
  end
  
  def send_push_notification(user_id, data)
    user = User.find(user_id)
    # In a real app, you would send a push notification here
    Rails.logger.info "Sending push notification to user #{user.id}"
  end
  
  def send_sms(user_id, data)
    user = User.find(user_id)
    # In a real app, you would send an SMS here
    Rails.logger.info "Sending SMS to user #{user.id}"
  end
end
