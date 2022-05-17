Sidekiq.configure_server do
  schedule_file = "config/schedule.yml"

  # Schedule Cron jobs from schedule.yml
  if File.exist?(schedule_file)
    Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
  end

end