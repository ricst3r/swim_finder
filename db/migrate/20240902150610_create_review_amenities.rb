class CreateReviewAmenities < ActiveRecord::Migration[7.1]
  def change
    create_table :review_amenities do |t|
      t.references :review, null: false, foreign_key: true
      t.references :amenity, null: false, foreign_key: true

      t.timestamps
    end
  end
end
