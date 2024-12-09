Rails.application.routes.draw do
  resources :service_requests
  resources :herbicides
  devise_scope :user do
    root to: 'users/sessions#new'  
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    unlocks: 'users/unlocks'
  }

  resources :users, only: [] do
    member do
      get 'complete_profile'
      patch 'update_profile'
    end
  end

  # root 'template#index'
  get 'dashboard/index', to: 'dashboard#index'

  get 'indice_setting', to: 'indice_setting#index', as: 'indice_setting'
put 'indice_setting/update', to: 'indice_setting#update', as: 'indice_setting_update'
post 'service_payement/', to: 'service_requests#service_payement', as: 'service_payement'
end
