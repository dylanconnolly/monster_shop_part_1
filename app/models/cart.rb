class Cart
  attr_reader :contents

  def initialize(contents)
    @contents = contents
  end

  def add_item(item)
    @contents[item] = 0 if !@contents[item]
    @contents[item] += 1
  end

  def total_items
    @contents.values.sum
  end

  def items
    item_quantity = {}
    @contents.each do |item_id,quantity|
      item_quantity[Item.find(item_id)] = quantity
    end
    item_quantity
  end

  def subtotal(item)
    (item.price/100) * @contents[item.id.to_s]
  end

  def total
    @contents.sum do |item_id,quantity|
      ((Item.find(item_id).price)/100) * quantity
    end
  end

  def discounted_total(coupon_code)
    coupon = Coupon.find_by_code(coupon_code)
    items.sum do |item, quantity|
      if item.merchant == coupon.merchant
        item.percent_discount(coupon.percent_off) * quantity
      else
        item.price * quantity
      end
    end/100
  end
  #
  # def add_quantity(item_id)
  #   @contents[item_id] += 1
  # end
  #
  # def subtract_quantity(item_id)
  #   @contents[item_id] -= 1
  # end

  # def limit_reached?(item_id)
  #   @contents[item_id] == Item.find(item_id).inventory
  # end
  #
  # def quantity_zero?(item_id)
  #   @contents[item_id] == 0
  # end
end
