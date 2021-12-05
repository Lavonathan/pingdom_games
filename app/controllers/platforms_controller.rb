class PlatformsController < ApplicationController
  def index
    @platforms = Platform.all
  end

  def show
    @platform = Platform.includes(:products).find(params[:id])
  end
end
