class Api::ProductsController < ApplicationController
  def all_products_method
    @products = Product.all
    render "all_products.json.jbuilder"
  end  

  def one_product_method
    input_id = params["id"]
    @product = Product.find_by(id: input_id)
    render "first_product.json.jbuilder"
  end
end
