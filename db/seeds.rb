# frozen_string_literal: true

require 'open-uri'
require 'faker'
require 'google_places'

# Set Faker locale to English
Faker::Config.locale = 'en'

# Force I18n locale to English
I18n.locale = :en

puts "Clearing existing data..."
ReviewAmenity.destroy_all
Amenity.destroy_all
Review.destroy_all
Location.destroy_all
User.destroy_all
Favorite.destroy_all

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


# Upload profile pictures to Cloudinary and assign to users
profile_pic_urls = [
  'https://res.cloudinary.com/dqdmlrr95/image/upload/v1725366300/glwuofhdx16mj8qb4arr.png',
  'https://res.cloudinary.com/dqdmlrr95/image/upload/v1725366301/gklyb0xzgojn5vk3u90p.png',
  'https://res.cloudinary.com/dqdmlrr95/image/upload/v1725366300/ac8mj3ebw6byttxqxqmk.png',
  'https://res.cloudinary.com/dqdmlrr95/image/upload/v1725366300/rkrypgnqgdixn567ihyu.png',
  'https://res.cloudinary.com/dqdmlrr95/image/upload/v1725366300/vfvygltbf9p2qc30xps9.png',
  'https://res.cloudinary.com/dqdmlrr95/image/upload/v1725366301/tv2xw3elhipuqfnkoye3.png',
  'https://res.cloudinary.com/dqdmlrr95/image/upload/v1725366301/tiwqroy96kkk5rjlvwnw.png',
  'https://res.cloudinary.com/dqdmlrr95/image/upload/v1725366300/gk9os3wvpnuuvbttzxc2.png'
]

users.each_with_index do |user, index|
  cloudinary_url = profile_pic_urls[index]
  user.image.attach(
    io: URI.open(cloudinary_url),
    filename: File.basename(cloudinary_url)
  )
end


# Replace your API key here
GOOGLE_PLACES_API_KEY = ENV['GOOGLE_PLACES_API_KEY']

# Initialize the client
client = GooglePlaces::Client.new(GOOGLE_PLACES_API_KEY)

puts "Creating locations using Google Places API..."
locations = []

10.times do |i|
  keyword = ['beach', 'swimming spot'][i % 2]
  break if locations.count >= 10
  spots = client.spots_by_query(keyword, types: 'natural_feature', detail: true)
  spots.each do |spot|
    break if locations.count >= 10
    location = Location.create!(
      name: spot.name,
      rating: spot.rating || rand(1..5),
      address: spot.formatted_address,
      latitude: spot.lat,
      longitude: spot.lng,
      user: users.sample
    )
    locations << location
    puts "Created location: #{location.name}"
  end
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
# Ensure each location has at least one review
locations.each do |location|
  user = users.sample
  Review.create!(
    content: Faker::Lorem.paragraph,
    rating: rand(1..5),
    user: user,
    location: location
  )
end

# Ensure each user has written at least one review
users.each do |user|
  next if user.reviews.any?
  Review.create!(
    content: Faker::Lorem.paragraph,
    rating: rand(1..5),
    user: user,
    location: locations.sample
  )
end

# Add additional random reviews
10.times do
  review = Review.create!(
    content: Faker::Lorem.paragraph,
    rating: rand(1..5),
    user: users.sample,
    location: locations.sample
  )

    # Associate 2-4 random amenities with each review
    amenities.sample(rand(2..4)).each do |amenity|
      ReviewAmenity.create!(review: review, amenity: amenity)
    end
  end

puts "Seed data created successfully!"

#Create favorites
puts "Creating favorites..."
users.each do |user|
  # Ensure each user has at least one favorite
  location = locations.sample
  f = Favorite.create!(user: user, location: location)
  # Randomly add more favorites for some users
  if rand < 0.5
    additional_favorites = rand(1..3)
    additional_favorites.times do
      location = locations.sample
      Favorite.create!(user: user, location: location)
    end
  end
end

# puts "Favorites created successfully!"
