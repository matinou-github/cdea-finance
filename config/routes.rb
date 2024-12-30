Rails.application.routes.draw do
  resources :remboursements
  resources :executions do
    collection do
      post 'upload_identity_card'
    end
  end
  resources :zone_assignments
  resources :service_requests do
    member do
      patch :update_status
    end
  end
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
      post 'upload_identity_card'
    end
  end
  resources :users, only: [:index, :show, :edit, :update, :destroy]
  
  namespace :users do
    get 'admin/new', to: 'admin#new', as: 'admin_new'
    post 'admin/create', to: 'admin#create', as: 'admin_create'
  end

  resources :dashboard, only: [] do
    collection do
      get :export_pdf, defaults: { format: :pdf }
    end
  end

  get 'template/index', to:'template#index'
  get 'dashboard/index', to: 'dashboard#index'
  get 'dashboard/list_user', to: 'dashboard#list_user'

  get 'dashboard/bilan', to: 'dashboard#bilan'
  get 'dashboard/profile', to: 'dashboard#profile'
  get 'dashboard/accueil', to: 'dashboard#accueil'
  get 'dashboard/success_payment', to: 'dashboard#success_payment'
  get 'indice_setting', to: 'indice_setting#index', as: 'indice_setting'
put 'indice_setting/update', to: 'indice_setting#update', as: 'indice_setting_update'
post 'service_payement/', to: 'service_requests#service_payement', as: 'service_payement'
patch '/service_requests/:id/payement_direct', to: 'service_requests#payement_direct', as: 'payement_direct'
#post 'service_requests/:id/convertir_garantie', to: 'service_requests#convertir_garantie', as: 'convertir_garantie'


resources :service_requests do
  member do
    post :convertir_garantie
  end
end


resources :balances do
  member do
    post :convertir_garantie
    post :appliquer_majoration
    post :reporter_valeur
  end
end

end
