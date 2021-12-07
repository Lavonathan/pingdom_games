class PublishersController < ApplicationController
  def index
    @publishers = Publisher.all
  end

  def show
    @publisher = Publisher.includes(:products).find(params[:id])
    @products = @publisher.products.page(params[:page]).per(10)
  end
end
