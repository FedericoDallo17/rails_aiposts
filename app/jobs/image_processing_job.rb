class ImageProcessingJob < ApplicationJob
  queue_as :default
  
  def perform(attachment_id, variant_name)
    attachment = ActiveStorage::Attachment.find(attachment_id)
    
    case variant_name
    when 'thumbnail'
      process_thumbnail(attachment)
    when 'medium'
      process_medium(attachment)
    when 'large'
      process_large(attachment)
    end
  end
  
  private
  
  def process_thumbnail(attachment)
    variant = attachment.variant(resize_to_limit: [150, 150])
    variant.processed
    Rails.logger.info "Processed thumbnail for attachment #{attachment.id}"
  end
  
  def process_medium(attachment)
    variant = attachment.variant(resize_to_limit: [500, 500])
    variant.processed
    Rails.logger.info "Processed medium size for attachment #{attachment.id}"
  end
  
  def process_large(attachment)
    variant = attachment.variant(resize_to_limit: [1200, 1200])
    variant.processed
    Rails.logger.info "Processed large size for attachment #{attachment.id}"
  end
end
