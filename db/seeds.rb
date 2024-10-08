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
  Faker::Config.locale = 'en'  # Set locale directly before user creation
  User.create!(
    email: "user#{i+1}@example.com",
    password: "password",
    name: Faker::Name.name,
    username: Faker::Internet.username,
    bio: Faker::Quote.famous_last_words
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
keywords = ['beach', 'swimming spot']
countries = ['USA', 'Brazil', 'Australia', 'Thailand', 'Greece', 'Spain', 'Japan', 'Mexico', 'South Africa', 'Indonesia', 'Philippines']
locations_per_country = 5
max_attempts_per_country = 20

# Initialize a cache for locations
location_cache = {}

countries.each do |country|
  country_locations = []
  attempts = 0

  while country_locations.count < locations_per_country && attempts < max_attempts_per_country
    keyword = keywords.sample
    next if location_cache.key?("#{keyword}-#{country}")  # Skip if already queried

    begin
      spots = client.spots_by_query("#{keyword} in #{country}", types: 'natural_feature', detail: true, fields: 'name,rating,formatted_address,geometry,photos')
      location_cache["#{keyword}-#{country}"] = spots  # Cache the results

      spots.each do |spot|
        break if country_locations.count >= locations_per_country
        location = Location.create!(
          name: spot.name,
          rating: spot.rating || rand(1..5),
          address: spot.formatted_address,
          latitude: spot.lat,
          longitude: spot.lng,
          user: users.sample
        )

        if spot.photos.any?
          photo_reference = spot.photos.first.photo_reference
          photo_url = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=#{photo_reference}&key=#{GOOGLE_PLACES_API_KEY}"
          location.image.attach(io: URI.open(photo_url), filename: "#{location.name.parameterize}.jpg")
          puts "Attached photo to location: #{location.name}"
        else
          puts "No photo available for location: #{location.name}"
        end

        country_locations << location
        locations << location
        puts "Created location: #{location.name} in #{country}"
      end
    rescue => e
      puts "Error fetching spots for '#{keyword}' in #{country}: #{e.message}"
    end
    attempts += 1
  end

  puts "Created #{country_locations.count} locations for #{country}"
end

puts "Total locations created: #{locations.count}"

if locations.empty?
  puts "Warning: No locations were created. You may need to check your Google Places API key or internet connection."
end

# Create amenities
puts "Creating amenities..."
amenities = [
  " 🅿️ Parking", "🏥 Lifeguard", "🚻 Restrooms", "🚿 Showers", "🍴 Food Vendors", "🏄‍♂️ Water Sports Allowed",
  "🏖️ Picnic Areas", "👨‍👩‍👧‍👦 Family Friendly", "🧘‍♂️ Relaxing"
].map { |title| Amenity.create!(title: title) }

# Create an array of 20 different Location Reviews
location_reviews = [
  "Beautiful beach with crystal clear water!",
  "Secluded spot, perfect for relaxation.",
  "Great waves for surfing, but be careful of strong currents.",
  "Stunning views, but limited facilities nearby.",
  "Family-friendly beach with calm waters.",
  "Hidden gem! Not too crowded and very clean.",
  "Amazing snorkeling spot with diverse marine life.",
  "Picturesque location, ideal for photography enthusiasts.",
  "Peaceful atmosphere, great for meditation and yoga.",
  "Perfect for long walks along the shoreline.",
  "Vibrant beach scene with lots of activities.",
  "Breathtaking sunset views from this spot.",
  "Excellent spot for kayaking and paddleboarding.",
  "Unique black sand beach, a must-visit!",
  "Quiet and serene, great for nature lovers.",
  "Rocky coastline with interesting tide pools to explore.",
  "Popular local hangout with a fun atmosphere.",
  "Impressive cliffs and rock formations nearby.",
  "Clear waters perfect for swimming and diving.",
  "Charming beach town with friendly locals."
]

# Modify the review creation loop
puts "Creating reviews..."
locations.each do |location|
  # Shuffle the users array to get a random order
  shuffled_users = users.shuffle

  # Create 4 reviews for each location, one from each user
  4.times do |i|
    review = Review.create!(
      content: location_reviews.sample,
      rating: rand(1..5),
      user: shuffled_users[i],
      location: location
    )

    # Associate 2-4 random amenities with each review
    amenities.sample(rand(2..4)).each do |amenity|
      ReviewAmenity.create!(review: review, amenity: amenity)
    end
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
