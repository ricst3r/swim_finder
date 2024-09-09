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
    puts "Create action called with params: #{params.inspect}"
    @favorite = Favorite.new(user_id: current_user.id, location_id: params[:location_id])
    if @favorite.save
      puts "Favorite saved successfully"
      redirect_to favorites_path
    else
      puts "Failed to save favorite: #{@favorite.errors.full_messages}"
      redirect_to root_path, alert: "Failed to add favorite"
    end
  end

  def destroy
    @favorite = Favorite.find(params[:id])
    @favorite.destroy
    redirect_to favorites_path
  end

end
