class Merchant::CouponsController < Merchant::BaseController

  def new
    @coupon = current_user.merchant.coupons.new
  end

  def index
    @coupons = Coupon.all
  end

  def create
    @coupon = current_user.merchant.coupons.new(coupon_params)
    if @coupon.save
      flash[:success] = "Coupon succesfully created!"
      redirect_to merchant_coupons_path
    else
      flash[:error] = @coupon.errors.full_messages.to_sentence
      render :new
    end
  end

  private

    def coupon_params
      params.require(:coupon).permit(:name, :code, :percent_off)
    end
end
