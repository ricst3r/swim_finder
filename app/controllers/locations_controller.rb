class LocationsController < ApplicationController

  def index
    @locations = Location.all
    # The `geocoded` scope filters only flats with coordinates
    @spots = @locations.geocoded.map do |location|
      {
        lat: location.latitude,
        lng: location.longitude
      }
    end
  end

  def show
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  private

  def location_params
  end

end
