class PagesController < ApplicationController

  def home
    if params[:query].present?
      @locations = Location.where("name ILIKE ?", "%#{params[:query]}%")
      if @locations.any?
        @center = [@locations.first.longitude, @locations.first.latitude]
      end
    else
      @locations = Location.all
    end
    @spots = []
  end

  def search_locations
    query = params[:query]
    # Implement your search logic here
    # For example, using Geocoder:
    results = Geocoder.search(query)
    if results.any?
      @center = { lat: results.first.latitude, lng: results.first.longitude }
      @locations = nearby_locations(@center)
    else
      @center = nil
      @locations = []
    end

    respond_to do |format|
      format.json { render json: { center: @center, locations: @locations } }
    end
  end

  private

  def nearby_locations(center)
    # Implement logic to find nearby locations
    # This is just an example
    Location.near([center[:lat], center[:lng]], 10)
  end
end
