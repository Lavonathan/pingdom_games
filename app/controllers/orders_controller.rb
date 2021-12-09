class OrdersController < ApplicationController

  before_action :authenticate_user!
  def show
    @order = Order.includes(:products, :product_orders).find(params[:id])

    # Redirect away if the order doesn't belong to the current user.
    if(@order.user != current_user)
      redirect_to root_path
    end
  end
end
