source 'https://rubygems.org'
ruby '2.3.0'

gem 'rails', '4.2.5'

gem 'aasm'
gem 'bcrypt'
gem 'cancancan'
gem 'figaro'
gem 'foreigner'
gem 'jbuilder'
gem 'pg'
gem 'rack-cors', require: 'rack/cors'
gem 'rails-api'
gem 'roadie-rails'
gem 'simplecov', require: false

# To fix this warning: warning: 2.2.x-compliant syntax, but you are running 2.3.0.
gem 'parser', '2.3.0.pre.6' # WORK-AROUND for Ruby 2.2.4

group :development do
  gem 'spring'
end

group :development, :test do
  gem 'awesome_print'
  gem 'dotenv-rails'
  gem 'fabrication'
  gem 'guard'
  gem 'guard-brakeman'
  gem 'guard-rspec', require: false
  gem 'rspec-rails', '~> 3.0'
  gem 'rspec-json_expectations'
  gem 'pry-rails'
  gem 'pry-nav'
  gem 'pry-stack_explorer'
  gem 'rubocop'
end

group :production do
  gem 'passenger'
  gem 'rails_12factor'
end
