Rails.application.routes.draw do
  # get 'publishers/index'
  # get 'publishers/show'
  # get 'genres/index'
  # get 'genres/show'
  # get 'platforms/show'
  # get 'platforms/index'
  # get 'products/index'
  # get 'products/show'
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root to: 'products#index'

  resources :products, only: [:index, :show]
  # get "/products", to: "products#index", as: "products" #products_path
  # get "/products/:id", to: "products#show", as: "product" #product_path

  resources :platforms, only: [:index, :show]
  # get "/platforms", to: "platforms#index", as: "platforms" #platforms_path
  # get "/platforms/:id", to: "platforms#show", as: "platform" #platform_path

  resources :genres, only: [:index, :show]
  # get "/genres", to: "genres#index", as: "genres" #genres_path
  # get "/genres/:id", to: "genres#show", as: "genre" #genre_path

  resources :publishers, only: [:index, :show]
  # get "/publishers", to: "publishers#index", as: "publishers" #publishers_path
  # get "/publishers/:id", to: "publishers#show", as: "publisher" #publisher_path
end

# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html