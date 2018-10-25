class Api::OrdersController < ApplicationController
  before_action :authenticate_user

  def index
    @orders = current_user.orders
    render "index.json.jbuilder"
  end

  def create
    product = Product.find_by(id: params[:product_id])

    @order = Order.new(
      product_id: params[:product_id],
      quantity: params[:quantity],
      user_id: current_user.id,
      subtotal: product.price * params[:quantity].to_i,
      tax: product.tax * params[:quantity].to_i,
      total: product.total * params[:quantity].to_i
    )
    @order.save
    render "show.json.jbuilder"
  end
end
