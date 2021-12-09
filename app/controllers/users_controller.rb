class UsersController < ApplicationController
  def show
    @user = current_user
  end

  before_action :authenticate_user!
  def orders
    @orders = current_user.orders
  end
end
