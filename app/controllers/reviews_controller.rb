class ReviewsController < ApplicationController

def new
  @review = Review.new
  @location = Location.find(params[:location_id])
end

def create
  @review = Review.new(review_params)
  @location = Location.find(params[:location_id])
  @review.location = @location
  @review.user = current_user
  @review.save
  redirect_to location_path(@location)
end

private

def review_params
  params.require(:review).permit(:content, :rating, :image)
end

end
