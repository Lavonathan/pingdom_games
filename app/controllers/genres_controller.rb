class GenresController < ApplicationController
  def index
    @genres = Genre.all
  end

  def show
    @genre = Genre.includes(:products).find(params[:id])
    @products = @genre.products.page(params[:page]).per(10)
  end
end
