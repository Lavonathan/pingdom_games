class CheckoutController < ApplicationController
  def create
    @products = params[:products]
    @total = params[:total].to_f.round(2)
    @gst = params[:gst].to_f.round(2)
    @hst = params[:hst].to_f.round(2)
    @pst = params[:pst].to_f.round(2)

    if @products.nil? || @total < 0 || @gst < 0 || @pst < 0 || @hst < 0
      flash[:notice] = ["There has been an error with checkout. Please contact administrator.", -1]
      redirect_to cart_show_path
    end

    # ruby inside of the javascript!...
    # executed on server to input data into the JS before the client receives it!
    respond_to do |format|
      format.js #render app/views/checkout/create.js.erb
    end


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
