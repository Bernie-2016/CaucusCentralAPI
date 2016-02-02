namespace :caucus do
  desc 'Update result counts from Microsoft'
  task :update_microsoft do
    return unless Time.now.in_time_zone('EST').to_date == Date.parse('02/02/2016')
    require Rails.root.join('app', 'workers', 'microsoft_data_worker.rb')
    MicrosoftDataWorker.perform_async
  end

  desc 'Email csv'
  task :email_csv do
    require Rails.root.join('app', 'workers', 'email_worker.rb')
    EmailWorker.perform_async
  end
end
