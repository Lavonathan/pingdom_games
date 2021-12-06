class ProductsController < ApplicationController
  def index
    @search_value = params[:keywords]

    @wildcard_search = "%#{@search_value}%"

    # Search based on game name.
    begin
      @product_total = Product.where("name LIKE ?", @wildcard_search)

      # If there is only one pokemon returned, go right to their show page.
      if @product_total.count == 1
        @product = @product_total.first
        redirect_to "/products/#{@product.id}"
      else
        @products = @product_total
      end
    end
  end

  def show
    @product = Product.includes(:platforms, :publisher, :genres).find(params[:id])
    @image = @product.image
  end
end
