class ReviewAmenity < ApplicationRecord
  belongs_to :review
  belongs_to :amenity
end
