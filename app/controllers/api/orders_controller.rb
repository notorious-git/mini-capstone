class Api::OrdersController < ApplicationController
  before_action :authenticate_user

  def index
    # @orders = current_user.orders
    # render "index.json.jbuilder"
  end

  def create
    calculated_subtotal = 0
    calculated_tax = 0
    calculated_total = 0
    carted_products = current_user.carted_products.where(status: "carted")
    carted_products.each do |carted_product|
      calculated_subtotal += carted_product.product.price * carted_product.quantity
      calculated_tax += carted_product.product.tax * carted_product.quantity
    end
    calculated_total = calculated_subtotal + calculated_tax

    @order = Order.new(
      user_id: current_user.id,
      subtotal: calculated_subtotal,
      tax: calculated_tax,
      total: calculated_total
    )
    @order.save

    # carted_products.each do |carted_product|
    #   carted_product.status = "purchased"
    #   carted_product.order_id = @order.id
    #   carted_product.save
    # end
    carted_products.update_all(status: "purchased", order_id: @order.id)


    render "show.json.jbuilder"
  end
end
