class LocationsController < ApplicationController

  def index
    @locations = Location.all
    # The `geocoded` scope filters only flats with coordinates

  end

  def show
    @location = Location.find(params[:id])
  end

  def new
    @location = Location.new
  end

  def create
    @location = Location.new(location_params)
    @location.user = current_user if user_signed_in?

    if @location.save
      # Broadcast the new location to all subscribers
      # Turbo::StreamsChannel.broadcast_append_to(
      #   "locations",
      #   target: "locations",
      #   partial: "locations/location",
      #   locals: { location: @location }
      # )
      redirect_to user_path(current_user.username), notice: 'Location created successfully.'
    else
      render :new
    end
  end

  def edit
    @location = Location.find(params[:id])
  end

  def update
  end

  def destroy
    @location = Location.find(params[:id])
    @location.destroy
    redirect_to user_path(current_user.username), notice: 'Location was successfully deleted.'
  end

  private

  def location_params
    params.require(:location).permit(:name, :rating, :address, :image)
  end

end
