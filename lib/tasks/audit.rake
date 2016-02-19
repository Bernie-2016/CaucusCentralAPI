namespace :caucus do
  desc 'Look for mismatches in results'
  task :audit do
    require Rails.root.join('app', 'workers', 'audit_worker.rb')
    AuditWorker.perform_async
  end
end
