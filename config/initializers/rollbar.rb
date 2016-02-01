Rollbar.configure do |config|
  config.enabled = false unless Rails.env.production?
  config.access_token = ENV['ROLLBAR_ACCESS_TOKEN']
  config.environment = ENV['ROLLBAR_ENV'] || Rails.env
end
