class AuditWorker
  include Sidekiq::Worker

  def perform
    AuditService.perform!
  end
end
