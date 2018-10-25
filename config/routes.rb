Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    get "/products" => "products#index"
    post "/products" => "products#create"
    get "/products/:id" => "products#show"
    patch "/products/:id" => "products#update"
    delete "/products/:id" => "products#destroy"

    get "/orders" => "orders#index"
    post "/orders" => "orders#create"

    post "/users" => "users#create"

    post "/sessions" => "sessions#create"
  end
end
