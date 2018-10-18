class Product < ApplicationRecord
  def is_discounted?
    price < 50
  end

  def tax
    price * 0.09
  end

  def total
    price + tax
  end
end
