set :output, {:error => 'log/error.log', :standard => 'log/cron.log'}
every 5.minutes do # Many shortcuts available: :hour, :day, :month, :year, :reboot
  runner "UpdatePostgresWorker.perform_async"
end