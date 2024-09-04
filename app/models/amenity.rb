class Amenity < ApplicationRecord
  has_many :reviews, through: :review_amenities
end
