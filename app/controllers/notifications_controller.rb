class NotificationsController < ApplicationController
  before_action :set_notification, only: [:show, :mark_read, :mark_unread, :destroy]
  
  def index
    notifications = current_user.notifications
                               .recent
                               .page(params[:page])
                               .per(20)
    
    render json: {
      notifications: notifications.map { |notification| notification_json(notification) },
      pagination: pagination_info(notifications)
    }
  end
  
  def show
    render json: notification_json(@notification)
  end
  
  def unread
    notifications = current_user.notifications
                               .unread
                               .recent
                               .page(params[:page])
                               .per(20)
    
    render json: {
      notifications: notifications.map { |notification| notification_json(notification) },
      pagination: pagination_info(notifications)
    }
  end
  
  def read
    notifications = current_user.notifications
                               .read
                               .recent
                               .page(params[:page])
                               .per(20)
    
    render json: {
      notifications: notifications.map { |notification| notification_json(notification) },
      pagination: pagination_info(notifications)
    }
  end
  
  def mark_read
    @notification.mark_as_read!
    render json: notification_json(@notification)
  end
  
  def mark_unread
    @notification.mark_as_unread!
    render json: notification_json(@notification)
  end
  
  def mark_all_read
    current_user.notifications.unread.update_all(read: true)
    render json: { message: 'All notifications marked as read' }
  end
  
  def destroy
    @notification.destroy
    render json: { message: 'Notification deleted successfully' }
  end
  
  def count
    unread_count = current_user.notifications.unread.count
    
    render json: {
      unread_count: unread_count
    }
  end
  
  private
  
  def set_notification
    @notification = current_user.notifications.find(params[:id])
  end
  
  def notification_json(notification)
    {
      id: notification.id,
      title: notification.title,
      content: notification.content,
      notification_type: notification.notification_type,
      read: notification.read,
      created_at: notification.created_at,
      updated_at: notification.updated_at
    }
  end
  
  def pagination_info(collection)
    {
      current_page: collection.current_page,
      total_pages: collection.total_pages,
      total_count: collection.total_count,
      per_page: collection.limit_value
    }
  end
end
