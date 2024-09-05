class Review < ApplicationRecord
  belongs_to :user
  belongs_to :location
  has_many :review_amenities
  has_many :amenities, through: :review_amenities
  has_one_attached :image
end
