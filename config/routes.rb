Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :trips do
    resources :flights, only: %i[new create edit update destroy]
    resources :recommendations, only: [:index]
    resources :events, only: %i[new create edit update]
  end
  resources :events, only: [:destroy]

  patch '/trips/:trip_id/events/:id/update_position', to: 'events#update_position', as: 'update_position'
  patch '/trips/:trip_id/events/:id/move_lists', to: 'events#move_lists', as: 'move_lists'
  get '/trips/:trip_id/overview', to: 'trips#overview', as: 'trip_overview'

  # Defines the root path route ("/")
  # root "articles#index"
end
