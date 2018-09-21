# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :v1 do
    root 'docs#index'
    
    resources :sessions, only: %i[create destroy]
    resources :label_types
    resources :label_templates
    resources :printers, only: %i[index show create]
    resources :print_jobs, only: [:create]

    get 'docs', to: 'docs#index'
  end

  match 'v1/test_exception_notifier', controller: 'application', action: 'test_exception_notifier', via: :get
end
