class CleanupJob < ApplicationJob
  queue_as :default
  
  def perform
    cleanup_old_notifications
    cleanup_orphaned_attachments
    cleanup_old_sessions
  end
  
  private
  
  def cleanup_old_notifications
    # Delete notifications older than 30 days
    old_notifications = Notification.where('created_at < ?', 30.days.ago)
    count = old_notifications.count
    old_notifications.delete_all
    Rails.logger.info "Cleaned up #{count} old notifications"
  end
  
  def cleanup_orphaned_attachments
    # Delete attachments that are no longer associated with any record
    orphaned_attachments = ActiveStorage::Attachment.left_joins(:record)
                                                  .where(active_storage_attachments: { record_id: nil })
    count = orphaned_attachments.count
    orphaned_attachments.destroy_all
    Rails.logger.info "Cleaned up #{count} orphaned attachments"
  end
  
  def cleanup_old_sessions
    # In a real app, you might have session cleanup logic here
    Rails.logger.info "Session cleanup completed"
  end
end
