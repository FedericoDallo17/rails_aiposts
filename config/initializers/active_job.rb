# Configure Active Job
Rails.application.configure do
  # Use solid_queue for job processing
  config.active_job.queue_adapter = :solid_queue
  
  # Configure queue names
  config.active_job.queue_name_prefix = "rails_aiposts"
  config.active_job.queue_name_delimiter = "_"
end
