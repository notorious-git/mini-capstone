class Api::ProductsController < ApplicationController
  def all_products_method
    render "all_products.json.jbuilder"
  end
end
