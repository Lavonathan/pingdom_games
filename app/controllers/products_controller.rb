class ProductsController < ApplicationController
  def index
    @search_value = params[:keywords]

    @wildcard_search = "%#{@search_value}%"

    puts "good 1"
    # Search based on game name.
    begin

      if params[:platform] != nil && params[:platform] != "Console"
        begin
          @platform = Platform.includes(:products).find(params[:platform])
          @product_total = @platform.products.where("name LIKE ?", @wildcard_search)
        rescue
          @platform = nil
          @product_total = Product.where("name LIKE ?", @wildcard_search)
        end
      else
        @platform = nil
        @product_total = Product.where("name LIKE ?", @wildcard_search)
      end

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
