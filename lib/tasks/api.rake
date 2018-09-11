# frozen_string_literal: true

if Rails.env.development?
  require 'raml'

  namespace :docs do
    desc 'generate the api docs'
    task :api do |_t|
      puts 'generating api docs...'
      Raml.document(Rails.root.join('config', 'api.raml'), Rails.root.join('app', 'views', 'v1', 'docs', 'index.html.erb'))
      puts 'done'
    end
  end
end
