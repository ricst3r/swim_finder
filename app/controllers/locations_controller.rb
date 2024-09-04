class LocationsController < ApplicationController

  def index
    @locations = Location.all
    # The `geocoded` scope filters only flats with coordinates
 
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
