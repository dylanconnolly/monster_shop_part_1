class Merchant::CouponsController < Merchant::BaseController

  def index
    @coupons = Coupon.where(merchant_id: current_user.merchant.id)
  end

  def new
    @coupon = current_user.merchant.coupons.new
  end

  def create
    @coupon = current_user.merchant.coupons.create(coupon_params)
    if @coupon.save
      flash[:success] = "Coupon succesfully created!"
      redirect_to merchant_coupons_path
    else
      flash[:error] = @coupon.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @coupon = Coupon.find(params[:id])
  end

  def update
    @coupon = Coupon.find(params[:id])
    if @coupon.update(coupon_params)
      flash[:success] = "Coupon updated successfully!"
      redirect_to merchant_coupons_path
    else
      flash[:error] = @coupon.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    Coupon.destroy(params[:id])
    redirect_to merchant_coupons_path
  end

  private

    def coupon_params
      params.require(:coupon).permit(:name, :code, :percent_off)
    end
end
