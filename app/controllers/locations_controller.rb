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
    # Ensure the location is associated with the current user if needed
    @location.user = current_user if user_signed_in?

    if @location.save
      # Redirect or render as appropriate
      redirect_to user_path(current_user.username), notice: 'Location created successfully.'
    else
      render :new
    end
  end

  def edit
  end

  def update
  end

  private

  def location_params
    params.require(:location).permit(:name, :rating, :address, :image)
  end

end
