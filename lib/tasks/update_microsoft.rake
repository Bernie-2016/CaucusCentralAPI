namespace :caucus do
  desc 'Update result counts from Microsoft'
  task :update_microsoft do
    require Rails.root.join('app', 'workers', 'microsoft_data_worker.rb')
    MicrosoftDataWorker.perform_async
  end
end
