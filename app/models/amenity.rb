class Amenity < ApplicationRecord
  has_many :locations, through: :location_amenities
end
