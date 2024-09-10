class Location < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?
  has_many :favorites, dependent: :destroy
  has_many :reviews, dependent: :destroy
  validates :address, presence: true
end
