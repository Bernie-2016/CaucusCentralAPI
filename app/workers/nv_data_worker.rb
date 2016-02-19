class NvDataWorker
  include Sidekiq::Worker

  def perform
    NvDataService.perform!
  end
end
