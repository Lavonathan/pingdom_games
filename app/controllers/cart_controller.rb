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

    flash[:notice] = ["➕#{quantity} #{'copy'.pluralize(quantity)} of #{product.name} #{quantity > 1 ? 'are' : 'is'} in the cart.", -2]

    redirect_back(fallback_location: root_path)
  end

  # DELETE /cart/:id
  def destroy
    # removes params[:id] from cart
    logger.debug("Removing #{params[:id]} from cart.")
    id = params[:id]
    session[:shopping_cart].delete(id)
    product = Product.find(id)
    flash[:notice] = ["➖ #{product.name} removed from cart.", -2]
    redirect_back(fallback_location: root_path)
  end

  def show
    @products = Product.find(session[:shopping_cart].keys)
    @cart = session[:shopping_cart]
    @cart_province = session[:cart_province]["id"]
    cart_province = session[:cart_province]
    @gst = (cart_province["GST"].to_f / 100).round(2)
    @pst = (cart_province["PST"].to_f / 100).round(2)
    @hst = (cart_province["HST"].to_f / 100).round(2)
    subtotal_all_products = 0

    @products.each do |product|
      subtotal = product.price * @cart["#{product.id}"]
      subtotal_all_products += subtotal
    end

    # Calculate total
    @gst_amount = subtotal_all_products * @gst.round(2)
    @hst_amount = subtotal_all_products * @hst.round(2)
    @pst_amount = subtotal_all_products * @pst.round(2)
    @total = (subtotal_all_products + @gst_amount + @hst_amount + @pst_amount).round(2)
    @subtotal_all_products = subtotal_all_products
  end

  def update_province
    province_id = params[:id]["province_id"]

    if(province_id != 0 && province_id != nil)
      session[:cart_province] = Province.find(province_id.to_i)
    end
    redirect_back(fallback_location: root_path)
  end
end