Rails.application.routes.draw do
  #get 'genres/index'
  #get 'genres/show'
  # get 'platforms/show'
  # get 'platforms/index'
  # get 'products/index'
  # get 'products/show'
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)


  # resources :products
  get "/products", to: "products#index", as: "products" #products_path
  get "/products/:id", to: "products#show", as: "product" #product_path

  # resources :platforms
  get "/platforms", to: "platforms#index", as: "platforms" #platforms_path
  get "/platforms/:id", to: "platforms#show", as: "platform" #platform_path

  # resources :genres
  get "/genres", to: "genres#index", as: "genres" #platforms_path
  get "/genres/:id", to: "genres#show", as: "genre" #platform_path
end

# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html