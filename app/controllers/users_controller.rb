class UsersController < ApplicationController

  def new

  end

  def create
    user = User.new(user_params)

    if user.save
      flash[:success] = "Account created!"
      redirect_to "/profile"
    else
      flash[:error] = "Incomplete form."
      render :new
    end
  end

  def show

  end

  private

    def user_params
      params.permit(:name, :address, :city, :state, :zip, :email, :password, :password_confirmation)
    end
end
