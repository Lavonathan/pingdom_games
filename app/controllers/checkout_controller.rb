class CheckoutController < ApplicationController
  def create
    products = params[:products].split(" ")
    @products = Product.includes(:publisher).find(products)

    @cart_province = session[:cart_province]["id"]
    @subtotal = params[:subtotal].to_f.round(2)
    @total = params[:total].to_f.round(2)
    @gst = params[:gst].to_f.round(2)
    @hst = params[:hst].to_f.round(2)
    @pst = params[:pst].to_f.round(2)
    @address = params[:address]
    @postal_code = params[:postal_code]

    if @products.nil? || @total < 0 || @gst < 0 || @pst < 0 || @hst < 0
      flash[:notice] = ["There has been an error with checkout. Please contact administrator.", -1]
      redirect_to cart_show_path
    end

    order = Order.create(order_no: Order.last.order_no + 1, payment_amount_no_tax: @subtotal, GST: @gst, HST: @hst, PST: @pst, province: Province.find(@cart_province),
                          payment_total: @total, pay_date: Date.current, user: current_user, address:current_user.address,
                          status: "NEW", postal_code:current_user.postal_code)

    session[:order_created] = order.id
    # Calculate and create hashes of all the line items. Also create product orders
    line_item_array = []

    @products.each do |product|

      # Create product order
      ProductOrder.create(product: product, order: order, quantity: session[:shopping_cart][product.id.to_s],
                    price: product.price)

      product_hash = {
        name: product.name,
        description: "Game published by #{product.publisher.name}",
        amount: (product.price * 100).to_i,
        currency: "cad",
        quantity: session[:shopping_cart][product.id.to_s]
      }

      line_item_array << product_hash
    end

    if @gst != 0
      line_item_array << {
        name: "GST",
        description: "Goods and Services Tax",
        amount: (@gst * 100).to_i,
        currency: "cad",
        quantity: 1
      }
    end

    if @pst != 0
      line_item_array << {
        name: "PST",
        description: "Provincial Sales Tax",
        amount: (@pst * 100).to_i,
        currency: "cad",
        quantity: 1
      }
    end

    if @hst != 0
      line_item_array << {
        name: "HST",
        description: "Harmonized Tax",
        amount: (@hst * 100).to_i,
        currency: "cad",
        quantity: 1
      }
    end

    # Establish a connection with Stripe and then redirect the user to the payment screen.

    # this call here, will have our server connect to stripe!
    # strip gem access to private key to setup the session behind the scenes
    # one of th bits of info is the INTERNAL ID for the session
    # so after this we need to provide that ID back to stripe for authentication.
    # That step happens in the JAVASCRIPT
    @session = Stripe::Checkout::Session.create(
      #went to stripe API, looked up sessions, figured it all out..
      payment_method_types: ["card"],
      success_url: checkout_success_url + "?session_id={CHECKOUT_SESSION_ID}",
      cancel_url: checkout_cancel_url,
      customer_email: current_user.email,
      line_items: line_item_array
    )

    # ruby inside of the javascript!...
    # executed on server to input data into the JS before the client receives it!
    redirect_to @session.url.to_s
    # respond_to do |format|
    #   format.js
    # end
  end

  def success
    #stripe success_url +"?session_id={CHECKOUT_SESSION_ID}"
    # when stripe redirects back to server... it will append this session_id  through GET params!
    @session = Stripe::Checkout::Session.retrieve(params[:session_id])
    @paid_flag = @session["payment_status"]

    if(@paid_flag != "paid" || session[:order_created] == nil)
      flash[:notice] = ["There was an error with the payment.", -1]
      redirect_to cart_show_path
    end

    # Update the order to paid
    order = Order.find(session[:order_created].to_i)
    order.status = "PAID"
    order.save

    session[:shopping_cart] = {}
    session[:cart_province] = current_user != nil ? current_user.province : Province.first
    flash[:notice] = ["Succes! We have received your payment.", -1]
    redirect_to controller: 'orders', action: 'show', id: session[:order_created].to_i
  end

  def cancel
    flash[:notice] = ["You have cancelled the payment.", -1]

    order = Order.find(session[:order_created].to_i)
    order.status = "CANCELLED"
    order.save
    redirect_to cart_show_path
  end
end
