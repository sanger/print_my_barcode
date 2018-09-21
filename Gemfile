# frozen_string_literal: true

source 'https://rubygems.org'

gem 'rails', '5.2.1'

group :development, :test do
  gem 'byebug'
  gem 'factory_bot_rails'
  gem 'mocha'
  gem 'pry'
  gem 'rspec-rails'
  gem 'ruby-prof', '~> 0.15.9'
  gem 'spring'
  gem 'sqlite3'
end

gem 'active_model_serializers', '~> 0.10'

gem 'puma'

gem 'bootsnap', require: false

# To use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano', :group => :development

gem 'exception_notification'

gem 'rubocop', require: false

gem 'rails-perftest'

gem 'rack-cors', require: 'rack/cors'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
group :development do
  gem 'listen', '~> 3.0'
  gem 'raml_ruby', '~> 0.1.1'
end

group :deployment do
  gem 'mysql2'
  gem 'psd_logger', github: 'sanger/psd_logger'
end
