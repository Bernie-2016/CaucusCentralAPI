require 'codeclimate-test-reporter'
require 'simplecov'

SimpleCov.formatter = CodeClimate::TestReporter::Formatter if ENV['CIRCLE_ARTIFACTS']
SimpleCov.start do
  add_filter 'app/workers'
  add_filter 'config'
  add_filter 'db'
  add_filter 'spec'
  add_group 'Controllers', 'app/controllers'
  add_group 'Models', 'app/models'
  add_group 'Mailers', 'app/mailers'
  add_group 'Serializers', 'app/serializers'
  add_group 'Services', 'app/services'
  coverage_dir 'spec/coverage'
end

ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'webmock/rspec'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

WebMock.disable_net_connect!(allow_localhost: true, allow: %w(codeclimate.com))

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!

  config.render_views = true

  config.include AuthHelper

  config.before(:suite) do
    DatabaseCleaner.clean_with :truncation
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.before(:all) do
    Rails.application.load_seed # loading seeds
  end
end
