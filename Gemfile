source 'https://rubygems.org'

gem 'rails', '>= 5.0.0.rc2', '< 5.1'

group :development, :test do
  gem 'factory_bot_rails'
  gem 'spring'
  gem 'byebug'
  gem 'sqlite3'
  gem 'rspec-rails', '~> 3.1'
  gem 'ruby-prof', '~> 0.15.9'
  gem 'mocha'
  gem 'pry'
end

gem 'active_model_serializers', '~> 0.10'

gem 'puma'

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

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
group :development do
  gem 'raml_ruby', '~> 0.1.1'
end

group :deployment do
  gem 'mysql2'
  gem 'psd_logger', github: 'sanger/psd_logger'
end
