
class Order < ApplicationRecord
  has_many :item_orders
  has_many :items, through: :item_orders
  belongs_to :user
  belongs_to :coupon, optional: true

  validates_presence_of :name,
                        :address,
                        :city,
                        :state,
                        :zip

  enum status: ["pending", "packaged", "shipped", "cancelled"]

  def grandtotal
    item_orders.sum('price * quantity')/100
  end

  def total_items
    item_orders.sum('quantity')
  end

  def total_quantity
    item_orders.sum(:quantity)
  end

  def self.status(status_searching_for)
    # can take argument of "packaged", "pending", "shipped", or "cancelled"
    where(status: "#{status_searching_for}")
  end

  def self.fulfill(order_id)
    Order.where(id: order_id).update(status: 1)
  end

  def coupon_total
    item_orders.sum do |item_order|
      if item_order.item.merchant == coupon.merchant
        item_order.item.percent_discount(coupon.percent_off) * item_order.quantity
      else
        item_order.price * item_order.quantity
      end
    end/100
  end
end
