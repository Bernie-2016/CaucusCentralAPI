namespace :caucus do
  desc 'Update result counts from NV Dems'
  task :update_nv do
    return unless Time.now.in_time_zone('EST').to_date == Date.parse('20/02/2016')
    require Rails.root.join('app', 'workers', 'nv_data_worker.rb')
    NvDataWorker.perform_async
  end
end
