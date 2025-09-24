# Use this file to easily define all of your cron jobs.
# Learn more: http://github.com/javan/whenever

# Run cleanup job daily at 2 AM
every 1.day, at: '2:00 am' do
  runner "CleanupJob.perform_later"
end

# Run notification digest weekly on Monday at 9 AM
every 1.week, at: '9:00 am' do
  runner "NotificationJob.perform_later('email_digest', User.pluck(:id), {})"
end
