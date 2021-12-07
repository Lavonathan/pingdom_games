class PlatformsController < ApplicationController
  def index
    @platforms = Platform.all
  end

  def show
    @platform = Platform.includes(:products).find(params[:id])
    @products = @platform.products.page(params[:page]).per(10)
  end
end
