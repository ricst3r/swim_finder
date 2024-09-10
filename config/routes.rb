Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root 'pages#entry'
  get '/home', to: 'pages#home', as: 'home'
  get 'entry_page', to: 'pages#entry'
  resources :locations do
    resources :reviews, only: [:new, :create]
    resources :favorites, only: [:create, :destroy]
  end

  resources :favorites, only: [:index, :destroy]

  get 'users/:username', to: 'users#show', as: :user, constraints: { username: /[^\/]+/ }

  get 'search_locations', to: 'pages#search_locations'

  resources :locations, only: [:new, :create,]

  resources :users do
    resources :chats, only: [:create]
  end

  resources :chats, only: [:show, :index, :destroy] do
    resources :messages, only: [:create]
  end
end
