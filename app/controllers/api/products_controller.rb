class Api::ProductsController < ApplicationController
  before_action :authenticate_admin, except: [:index, :show]

  def index
    @products = Product.all

    if params[:category]
      category = Category.find_by(name: params[:category])
      @products = category.products
    end

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
      description: params["description"],
      supplier_id: params["supplier_id"]
    )
    if @product.save
      Image.create(
        url: params[:image_url],
        product_id: @product.id
      )
      render "show.json.jbuilder"
    else
      render json: {errors: @product.errors.full_messages}, status: :unprocessable_entity
    end
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
    @product.description = params["description"] || @product.description
    if @product.save
      render "show.json.jbuilder"
    else
      render json: {errors: @product.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def destroy
    input_id = params["id"]
    @product = Product.find_by(id: input_id)
    @product.destroy
    render json: {message: "Product successfully destroyed!"}
  end
end
