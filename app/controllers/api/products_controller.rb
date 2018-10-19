class Api::ProductsController < ApplicationController
  def index
    @products = Product.all

    input_search_name = params[:q]
    if input_search_name
      @products = @products.where("name ILIKE ?", "%" + input_search_name + "%")
    end

    price_sort = params[:sort_by_price]
    if price_sort
      @products = @products.order(:price)
    else
      @products = @products.order(:id)
    end

    render "index.json.jbuilder"
  end

  def create
    @product = Product.new(
      name: params["name"],
      price: params["price"],
      image_url: params["image_url"],
      description: params["description"]
    )
    @product.save
    render "show.json.jbuilder"
  end

  def show
    input_id = params["id"]
    @product = Product.find_by(id: input_id)
    render "show.json.jbuilder"
  end

  def update
    input_id = params["id"]
    @product = Product.find_by(id: input_id)
    @product.name = params["name"] || @product.name
    @product.price = params["price"] || @product.price
    @product.image_url = params["image_url"] || @product.image_url
    @product.description = params["description"] || @product.name
    render "show.json.jbuilder"
  end

  def destroy
    input_id = params["id"]
    @product = Product.find_by(id: input_id)
    @product.destroy
    render json: {message: "Product successfully destroyed!"}
  end
end
