class MicrosoftDataWorker
  include Sidekiq::Worker

  def perform
    MicrosoftDataService.perform!
  end
end
