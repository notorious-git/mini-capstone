Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    get "/all_products_url" => "products#all_products_method"
    get "/first_product_url" => "products#first_product_method"
  end
end
