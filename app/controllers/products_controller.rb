class ProductsController < ApplicationController
  def index
    @products = Product.all
  end

  def show
    @product = Product.includes(:platforms, :publisher, :genres).find(params[:id])
  end
end
