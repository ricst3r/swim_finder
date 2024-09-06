class Amenity < ApplicationRecord
  has_many :reviews, through: :review_amenities
  def icon
    case title.downcase
    when 'wifi' then 'wifi'
    when 'parking' then 'p-square'
    when 'pool' then 'water'
    # Add more mappings as needed
    else 'check-circle'  # Default icon
    end
  end
end
