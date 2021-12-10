class CheckoutController < ApplicationController
  def create
    products = params[:products].split(" ")
    @products = Product.includes(:publisher).find(products)

    @total = params[:total].to_f.round(2)
    @gst = params[:gst].to_f.round(2)
    @hst = params[:hst].to_f.round(2)
    @pst = params[:pst].to_f.round(2)

    if @products.nil? || @total < 0 || @gst < 0 || @pst < 0 || @hst < 0
      flash[:notice] = ["There has been an error with checkout. Please contact administrator.", -1]
      redirect_to cart_show_path
    end

    # Calculate and create hashes of all the line items.
    line_item_array = []

    @products.each do |product|
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
      success_url: checkout_success_url,
      cancel_url: checkout_cancel_url,
      line_items: line_item_array
    )

    # ruby inside of the javascript!...
    # executed on server to input data into the JS before the client receives it!
    redirect_to @session.url.to_s
    # respond_to do |format|
    #   format.js
    # end

    # Establish a connection with Stripe.

    # redirect to the stripe payment screen.
  end

  def success
    # WE TOOK THEIR MONEY!
  end

  def cancel
    # something went wrong :(
  end
end
