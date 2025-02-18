# frozen_string_literal: true

source 'https://rubygems.org'

gem 'rails', '~> 8.0.1'

group :development, :test do
  gem 'byebug'
  gem 'factory_bot_rails', require: false
  gem 'mocha'
  gem 'pry'
  gem 'rails-perftest'
  gem 'rspec-rails'
  gem 'rubocop', require: false
  gem 'rubocop-factory_bot', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'ruby-prof'
  gem 'spring'
  gem 'sqlite3'
  gem 'syslog' # no longer part of the standard library in ruby 3.4
end

gem 'active_model_serializers'

gem 'puma'

gem 'bootsnap', require: false

gem 'exception_notification', git: 'https://github.com/smartinez87/exception_notification.git',
                              branch: 'master'

gem 'rack-cors', require: 'rack/cors'

gem 'sprint_client'

group :development do
  gem 'listen', '~> 3.0'
end

group :deployment do
  gem 'mysql2'
  gem 'psd_logger', github: 'sanger/psd_logger'
end
