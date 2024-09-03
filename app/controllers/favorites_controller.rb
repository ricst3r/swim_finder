class FavoritesController < ApplicationController

  def index
      @favorites = Favorite.all
  end

  def create
  end

end
