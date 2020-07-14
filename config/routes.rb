Rails.application.routes.draw do
  resources :categories
  resources :recipes do
    collection do
      get :import
      post :confirm
    end
  end
  root 'static_pages#home'
  resources :users
  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
end
