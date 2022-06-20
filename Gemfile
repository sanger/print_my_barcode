# frozen_string_literal: true

source 'https://rubygems.org'

gem 'rails', '~>6.1.0'

group :development, :test do
  gem 'byebug'
  gem 'factory_bot_rails'
  gem 'mocha'
  gem 'pry'
  gem 'rspec-rails'
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'ruby-prof'
  gem 'rails-perftest'
  gem 'spring'
  gem 'sqlite3'
end

gem 'active_model_serializers'

gem 'puma'

gem 'bootsnap', require: false

gem 'exception_notification'

gem 'rack-cors', require: 'rack/cors'

gem 'sprint_client'

group :development do
  gem 'listen', '~> 3.0'
  gem 'raml_ruby', '~> 0.1.1'
end

group :deployment do
  gem 'mysql2'
  gem 'psd_logger', github: 'sanger/psd_logger'
end
