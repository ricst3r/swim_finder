class ReviewsController < ApplicationController

def new
  @location = Location.find(params[:location_id])
  @review = @location.reviews.build
end

end
