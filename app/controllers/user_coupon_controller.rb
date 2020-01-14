class UserCouponController < ApplicationController

  def create
    if Coupon.find_by_code(params[:coupon_code]) != nil
      session[:coupon] = params[:coupon_code]
      flash[:success] = "Coupon code applied!"
    else
      flash[:error] = "Invalid coupon code."
    end
    redirect_to '/cart'
  end
end
