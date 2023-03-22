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

  patch 'drag/event'

  # Defines the root path route ("/")
  # root "articles#index"
end
