# frozen_string_literal: true

require 'open-uri'
require 'faker'

Faker::Config.locale = :en

puts "Clearing existing data..."
ReviewAmenity.destroy_all
Amenity.destroy_all
Review.destroy_all
Location.destroy_all
User.destroy_all

# Create 4 users
puts "Creating users..."
users = 4.times.map do |i|
  User.create!(
    email: "user#{i+1}@example.com",
    password: "password",
    name: Faker::Name.name,
    username: Faker::Internet.username,
    bio: Faker::Lorem.paragraph
  )
end

# Create 10 locations (beaches and swimming spots)
puts "Creating locations..."
locations = [
  "Bondi Beach", "Waikiki Beach", "Copacabana Beach", "Phi Phi Islands",
  "Maldives", "Great Barrier Reef", "Cinque Terre", "Santorini",
  "Bora Bora", "Palawan"
].map do |name|
  Location.create!(
    name: name,
    rating: rand(1..5),
    latitude: Faker::Address.latitude,
    longitude: Faker::Address.longitude,
    user: users.sample
  )
end

# Define Cloudinary Image URLs
cloudinary_urls = [
  "https://res.cloudinary.com/dqdmlrr95/image/upload/v1725306179/swimfinder/hr0t9uv7hyfx08bo5c9a.jpg",
  "https://res.cloudinary.com/dqdmlrr95/image/upload/v1725306181/swimfinder/nlogrhezgmn2phak6wtw.webp",
  "https://res.cloudinary.com/dqdmlrr95/image/upload/v1725306179/swimfinder/groirogbnswzpclymt74.jpg",
  "https://res.cloudinary.com/dqdmlrr95/image/upload/v1725306180/swimfinder/sjj3llrxmruxy85ohzua.webp",
  "https://res.cloudinary.com/dqdmlrr95/image/upload/v1725306180/swimfinder/nbycwgfpp630jtifg13j.jpg",
  "https://res.cloudinary.com/dqdmlrr95/image/upload/v1725306180/swimfinder/gqwijgwpwqaz6clzdi4g.jpg",
  "https://res.cloudinary.com/dqdmlrr95/image/upload/v1725306181/swimfinder/zwtsysndkjybwkceeejv.jpg",
  "https://res.cloudinary.com/dqdmlrr95/image/upload/v1725306180/swimfinder/ituyeovjfcxbetwtlc7p.jpg",
  "https://res.cloudinary.com/dqdmlrr95/image/upload/v1725306180/swimfinder/gv4mpg3iq1hbqwlh5cc8.jpg",
  "https://res.cloudinary.com/dqdmlrr95/image/upload/v1725306181/swimfinder/hvhtk5svdhuhxq1rn3gj.webp",
]

puts "Attaching Cloudinary images to locations..."
locations.each_with_index do |location, index|
  cloudinary_url = cloudinary_urls[index]
  location.image.attach(
    io: URI.open(cloudinary_url),
    filename: File.basename(cloudinary_url)
  )
end

# Create amenities
puts "Creating amenities..."
amenities = [
  "Parking", "Lifeguard", "Restrooms", "Showers", "Food Vendors",
  "Beach Umbrellas", "Water Sports", "Picnic Areas"
].map { |title| Amenity.create!(title: title) }

# Create 8 reviews (2 for each user) and associate amenities
puts "Creating reviews and associating amenities..."
users.each do |user|
  2.times do
    review = Review.create!(
      content: Faker::Lorem.paragraph,
      rating: rand(1..5),
      user: user,
      location: locations.sample
    )

    # Associate 2-4 random amenities with each review
    amenities.sample(rand(2..4)).each do |amenity|
      ReviewAmenity.create!(review: review, amenity: amenity)
    end
  end
end

puts "Seed data created successfully!"
