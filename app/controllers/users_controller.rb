class UsersController < ApplicationController
  def show
  end

  before_action :authenticate_user!
  def orders
    @orders = current_user.orders
  end
end
