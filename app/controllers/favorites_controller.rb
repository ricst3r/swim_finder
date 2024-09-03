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
  end

end
