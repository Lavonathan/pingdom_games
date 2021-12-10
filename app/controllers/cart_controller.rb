class CartController < ApplicationController
  # POST /cart
  # Data sent as form data (params)
  def create
    # the logger will show in the rails server.. super useful for debugging!!
    product_id = params[:id].to_i
    quantity = params[:quantity].to_i

    logger.debug("Adding #{product_id} to cart.")
    product = Product.find(product_id)

    session[:shopping_cart][product_id] = quantity

    flash[:notice] = "➕#{quantity} #{'copy'.pluralize(quantity)} of #{product.name} are in cart."

    redirect_back(fallback_location: root_path)
  end

  # DELETE /cart/:id
  def destroy
    # removes params[:id] from cart
    logger.debug("Removing #{params[:id]} from cart.")
    id = params[:id]
    session[:shopping_cart].delete(id)
    product = Product.find(id)
    flash[:notice] = "➖ #{product.name} removed from cart."
    redirect_back(fallback_location: root_path)
  end
end