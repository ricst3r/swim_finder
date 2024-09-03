class FavoritesController < ApplicationController

  def index
      @favorites = Favorite.where(user_id: current_user.id)
  end

  def create
  end

end
