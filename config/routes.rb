Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root "welcome#index"

  resources :merchants

  resources :items, except: [:create, :new] do
    resources :reviews, only: [:new, :create]
  end

  get "/merchants/:merchant_id/items", to: "items#index"
  get "/merchants/:merchant_id/items/new", to: "items#new"
  post "/merchants/:merchant_id/items", to: "items#create"
  get 'merchants/:merchant_id/items/:items_id/edit', to: "items#edit"
  patch 'merchants/:merchant_id/items/:item_id', to: "merchant/items#update"
  delete 'merchants/:merchant_id/items/:item_id', to: "merchant/items#destroy"

  resources :reviews, only: [:edit, :update, :destroy]

  post "/cart/:item_id", to: "cart#add_item"
  get "/cart", to: "cart#show"
  delete "/cart", to: "cart#empty"
  delete "/cart/:item_id", to: "cart#remove_item"
  delete "/cart/:item_id/quantity", to: "cart#remove_item_quantity"

  resources :orders, only: [:new, :create, :show, :update]

  get "/register", to: "users#new"
  post "/users", to: "users#create"
  get "/users", to: "sessions#show"
  get "/profile", to: "users#show"
  get "/profile/orders", to: "orders#index"
  get "profile/orders/:id", to: "orders#show"

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  get "/profile/edit", to: "users#edit"
  patch "/profile", to: "users#update"
  get "/profile/password/edit", to: "users#edit"
  patch "/profile/password", to: "users#update"

  post "/coupons", to: "user_coupon#create"

  namespace :merchant do
    get '/', to: "merchant#show"
    resources :orders, only: :show
    get '/:merchant_id/items', to: "items#index"
    get '/:merchant_id/items/new', to: "items#new"
    post '/:merchant_id/items', to: "items#create"
    get '/orders/:order_id/item_orders/:item_order_id/fulfill', to: 'item_orders#fulfill'
    resources :coupons
  end

  namespace :admin do
    get '/', to: "admins#show"
    resources :merchants, only: [:index, :update, :show]
    get '/users', to: "users#index"
    get '/users/:user_id/', to: "users#show"
    get '/users/:user_id/profile/edit', to: "users#edit"
    patch '/users/:user_id/profile', to: "users#update"
    get '/users/:user_id/password/edit', to: "users#edit"
    patch 'users/:user_id/password', to: "users#update"
    get '/users/:user_id/upgrade_to_merchant_employee', to: "users#change_role"
    get '/users/:user_id/upgrade_to_merchant_admin', to: "users#change_role"
    patch '/orders/:id', to: "orders#update"
  end

  scope :admin do
    get '/merchants/:merchant_id/items', to: "merchant/items#index"
  end
end
