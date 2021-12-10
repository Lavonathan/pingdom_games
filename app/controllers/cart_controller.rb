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

    flash[:notice] = ["➕#{quantity} #{'copy'.pluralize(quantity)} of #{product.name} #{quantity > 1 ? 'are' : 'is'} in the cart.", product.id]

    redirect_back(fallback_location: root_path)
  end

  # DELETE /cart/:id
  def destroy
    # removes params[:id] from cart
    logger.debug("Removing #{params[:id]} from cart.")
    id = params[:id]
    session[:shopping_cart].delete(id)
    product = Product.find(id)
    flash[:notice] = ["➖ #{product.name} removed from cart.", product.id]
    redirect_back(fallback_location: root_path)
  end

  def show
    @products = Product.find(session[:shopping_cart].keys)
    @cart = session[:shopping_cart]
    @gst = (current_user.province.GST.to_f / 100).round(2)
    @pst = (current_user.province.PST.to_f / 100).round(2)
    @hst = (current_user.province.HST.to_f / 100).round(2)

    subtotal_all_products = 0

    @products.each do |product|
      subtotal = product.price * @cart["#{product.id}"]
      subtotal_all_products += subtotal
    end

    # Calculate total
    gst = subtotal_all_products * @gst.round(2)
    hst = subtotal_all_products * @hst.round(2)
    pst = subtotal_all_products * @pst.round(2)
    @total = subtotal_all_products + gst + hst + pst
    @subtotal_all_products = subtotal_all_products
  end
end