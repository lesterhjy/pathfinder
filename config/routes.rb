Rails.application.routes.draw do
  require "sidekiq/web"
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :trips do
    resources :flights, only: %i[new create edit update destroy]
    resources :recommendations, only: [:index]
    resources :events, only: %i[new create edit update destroy]
    resources :hotels, only: %i[new create edit update destroy]
  end
  # resources :events, only: [:destroy]
  resources :user_trips, only: [:destroy]
  patch '/trips/:trip_id/events/:id/update_position', to: 'events#update_position', as: 'update_position'
  patch '/trips/:trip_id/events/:id/move_lists', to: 'events#move_lists', as: 'move_lists'
  get 'trips/:trip_id/invite', to: 'trips#invite', as: 'trip_invite'
  get '/trips/:trip_id/overview', to: 'trips#overview', as: 'trip_overview'
  post "/trips/:trip_id/overview/send_email", to: 'trips#send_email', as: 'send_email'
  # Defines the root path route ("/")
  # root "articles#index"
end
