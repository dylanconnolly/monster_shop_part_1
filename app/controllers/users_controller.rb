class UsersController < ApplicationController

  def new

  end

  def create
    user = User.new(user_params)

    if user.save
      flash[:success] = "Account created!"
      redirect_to "/profile"
    end
    flash[:error] = "Incomplete form."
    require "pry"; binding.pry
  end

  private

    def user_params
      params.permit(:name, :address, :city, :state, :zip, :email, :password, :password_confirmation)
    end
end
