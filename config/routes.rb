Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :v1 do
    resources :sessions, only: [:create, :destroy]
    resources :label_types
    resources :label_templates
    resources :printers, only: [:index, :show, :create]
    resources :print_jobs, only: [:create]

    get 'docs', to: 'docs#index'
    root 'docs#index'

  end

  match 'v1/test_exception_notifier', controller: 'application', action: 'test_exception_notifier', via: :get

end
