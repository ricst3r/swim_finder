class FavoritesController < ApplicationController
  before_action :authenticate_user!  # Add this line if using Devise

  def index
    if current_user
      @favorites = Favorite.where(user_id: current_user.id)
    else
      # Handle the case when there's no current user
      redirect_to login_path, alert: "Please log in to view your favorites."
    end
  end

  def create
    @favorite = Favorite.new(user_id: current_user.id, location_id: params[:location_id])
    @favorite.save
    redirect_to favorites_path
  end

  def destroy
    @favorite = Favorite.find(params[:id])
    @favorite.destroy
    redirect_to favorites_path
  end

end
