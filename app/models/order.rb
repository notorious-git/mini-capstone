class Order < ApplicationRecord
  belongs_to :user
  has_many :carted_products
  has_many :products, through: :carted_products

  def calculate_money
    calculated_subtotal = 0
    calculated_tax = 0
    calculated_total = 0
    self.carted_products.each do |carted_product|
      calculated_subtotal += carted_product.product.price * carted_product.quantity
      calculated_tax += carted_product.product.tax * carted_product.quantity
    end
    calculated_total = calculated_subtotal + calculated_tax
    self.update(subtotal: calculated_subtotal, tax: calculated_tax, total: calculated_total)
  end
end
