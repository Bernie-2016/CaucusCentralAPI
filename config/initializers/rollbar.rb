if Rails.env.prduction?
  Rollbar.configure do |config|
    config.access_token = ENV['ROLLBAR_ACCESS_TOKEN']
    config.environment = ENV['ROLLBAR_ENV'] || Rails.env
  end
end
