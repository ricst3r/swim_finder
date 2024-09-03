class ReviewsController < ApplicationController

def new
  @review = Review.new
  @location = Location.find(params[:location_id])
end

end
