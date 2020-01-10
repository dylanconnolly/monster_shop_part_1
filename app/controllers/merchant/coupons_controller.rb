class Merchant::CouponsController < Merchant::BaseController

  def new
    @coupon = current_user.merchant.coupons.new
  end

  def index
    @coupons = Coupon.all
  end

  def create
    
  end
end
