Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by uptime monitors and load balancers.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "home#index"

  # Authentication routes
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'

  # User dashboard and profile
  get '/dashboard', to: 'dashboard#index'
  get '/profile', to: 'users#show'
  get '/profile/edit', to: 'users#edit'
  patch '/profile', to: 'users#update'

  # Events
  resources :events, only: [:index, :show] do
    member do
      post :register
      delete :unregister
    end
  end

  # Swiping system
  get '/swipe', to: 'swipe#index'
  get '/swipe/events/:event_id', to: 'swipe#event', as: 'swipe_event'
  post '/swipe/user', to: 'swipe#swipe_user'

  # Matches and messaging
  get '/matches', to: 'matches#index'
  get '/matches/:id', to: 'matches#show', as: 'match'
  resources :messages, only: [:create]

  # PWA manifest
  get '/manifest', to: 'pwa#manifest'
  get '/service-worker', to: 'pwa#service_worker'
end
