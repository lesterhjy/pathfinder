Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :trips, only: [:show] do
    resources :recommendations, only: [:index]
    resources :events, only: [:new, :create]
  end

  # Defines the root path route ("/")
  # root "articles#index"
end
