class Api::OrdersController < ApplicationController
  before_action :authenticate_user

  def index
    @orders = current_user.orders
    render "index.json.jbuilder"
  end

  def create
    @order = Order.new(
      user_id: current_user.id
    )
    @order.save
    carted_products = current_user.carted_products.where(status: "carted")
    carted_products.update_all(status: "purchased", order_id: @order.id)
    @order.calculate_money
    render "show.json.jbuilder"
  end
end
