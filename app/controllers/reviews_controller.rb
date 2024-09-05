class ReviewsController < ApplicationController
  before_action :authenticate_user!

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
  review_params[:amenity_ids].each do |amenity_id|
    ReviewAmenity.create(review: @review, amenity_id: amenity_id)
  end
  redirect_to location_path(@location)
end

private

def review_params
  params.require(:review).permit(:content, :rating, :image, amenity_ids: [])
end

end
