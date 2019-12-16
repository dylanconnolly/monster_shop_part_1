class UsersController < ApplicationController

  def new

  end

  def create
    user = User.new(user_params)
  end

  private

    def user_params
      params.permit()
    end
end
