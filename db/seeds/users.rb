puts "👥 Creating users..."

# Helper method to select random interests for a user based on their personality
def select_interests_for_user(user_type)
  case user_type
  when :music_lover
    base_interests = ["🎵 Music", "🎸 Guitar", "🎤 Karaoke", "🎺 Jazz", "🎵 Music Festivals"]
    additional = User::AVAILABLE_INTERESTS.sample(3)
  when :tech_entrepreneur  
    base_interests = ["💻 Technology", "🚀 Startups", "💼 Business", "📈 Finance"]
    additional = User::AVAILABLE_INTERESTS.sample(4)
  when :artist
    base_interests = ["🎨 Art", "📸 Photography", "🎭 Museums", "🎨 Painting", "✍️ Writing"]
    additional = User::AVAILABLE_INTERESTS.sample(3)
  when :athlete
    base_interests = ["🏃‍♂️ Running", "🏋️‍♂️ Fitness", "🏀 Basketball", "⚽ Soccer", "🏈 Football"]
    additional = User::AVAILABLE_INTERESTS.sample(3)
  when :chef
    base_interests = ["🍕 Food", "👩‍🍳 Cooking", "🍷 Wine", "🍜 Ramen", "🍣 Sushi"]
    additional = User::AVAILABLE_INTERESTS.sample(3)
  when :comedian
    base_interests = ["🎪 Comedy", "🎭 Theater", "🍺 Beer", "🎮 Gaming", "🎬 Movies"]
    additional = User::AVAILABLE_INTERESTS.sample(3)
  when :teacher
    base_interests = ["📚 Reading", "✍️ Writing", "☕ Coffee", "🎭 Theater", "🐱 Cats"]
    additional = User::AVAILABLE_INTERESTS.sample(3)
  when :dancer
    base_interests = ["💃 Dancing", "🎵 Music", "🏖️ Beach", "🌮 Mexican Food", "🎭 Shows"]
    additional = User::AVAILABLE_INTERESTS.sample(3)
  when :photographer
    base_interests = ["📸 Photography", "🥾 Hiking", "🌿 Nature", "✈️ Travel", "🐕 Dogs"]
    additional = User::AVAILABLE_INTERESTS.sample(3)
  when :outdoor_guide
    base_interests = ["🥾 Hiking", "🧗‍♂️ Rock Climbing", "🏕️ Camping", "🚴‍♂️ Biking", "🍺 Craft Beer"]
    additional = User::AVAILABLE_INTERESTS.sample(3)
  else
    base_interests = []
    additional = User::AVAILABLE_INTERESTS.sample(6)
  end
  
  (base_interests + additional).uniq.first(8).to_json
end

users_data = [
  {
    email: "alice@example.com",
    username: "alice_wonder",
    password: "password123",
    password_confirmation: "password123",
    first_name: "Alice",
    last_name: "Johnson",
    date_of_birth: 25.years.ago,
    bio: "Adventure seeker and coffee enthusiast. Love exploring new places and meeting interesting people!",
    city: "San Francisco, CA",
    interests: ["🎵 Music", "🥾 Hiking", "📚 Reading", "☕ Coffee", "🎭 Theater"].to_json,
    occupation: "Software Developer",
    education: "UC Berkeley - Computer Science",
    height: "5'6\""
  },
  {
    email: "bob@example.com",
    username: "bob_techie",
    first_name: "Bob",
    last_name: "Smith",
    bio: "Tech conference addict and startup founder. Love networking and learning about new technologies. Always building something cool! 💻",
    password: "password123",
    date_of_birth: Date.new(1992, 7, 22),
    city: "Austin",
    interests: select_interests_for_user(:tech_entrepreneur),
    occupation: "Tech Entrepreneur",
    education: "Stanford University - Computer Science",
    height: "5'11\"",
    photos: ["bob_main.jpg", "bob_conference.jpg", "bob_running.jpg", "bob_office.jpg"].to_json
  },
  {
    email: "carol@example.com",
    username: "carol_artist",
    first_name: "Carol",
    last_name: "Davis",
    bio: "Art gallery enthusiast and painter. Always up for cultural events! Love abstract art and photography. Creative soul seeking artistic adventures! 🎨",
    password: "password123",
    date_of_birth: Date.new(1996, 11, 8),
    city: "New York",
    interests: select_interests_for_user(:artist),
    occupation: "Graphic Designer",
    education: "Parsons School of Design - Fine Arts",
    height: "5'4\"",
    photos: ["carol_main.jpg", "carol_painting.jpg", "carol_gallery.jpg", "carol_wine.jpg"].to_json
  },
  {
    email: "david@example.com",
    username: "david_sports",
    first_name: "David",
    last_name: "Wilson",
    bio: "Sports fan and marathon runner. Love attending live sports events and staying active. Certified personal trainer who loves motivating others! 💪",
    password: "password123",
    date_of_birth: Date.new(1990, 5, 12),
    city: "Los Angeles",
    interests: select_interests_for_user(:athlete),
    occupation: "Personal Trainer",
    education: "UCLA - Kinesiology",
    height: "6'2\"",
    photos: ["david_main.jpg", "david_marathon.jpg", "david_gym.jpg", "david_sports.jpg"].to_json
  },
  {
    email: "emma@example.com",
    username: "emma_foodie",
    first_name: "Emma",
    last_name: "Brown",
    bio: "Food lover and cooking enthusiast. Always hunting for the best food festivals! Chef at a local restaurant. Let's explore the culinary world together! 👩‍🍳",
    password: "password123",
    date_of_birth: Date.new(1994, 9, 3),
    city: "Chicago",
    interests: select_interests_for_user(:chef),
    occupation: "Chef",
    education: "Culinary Institute of America",
    height: "5'5\"",
    photos: ["emma_main.jpg", "emma_cooking.jpg", "emma_restaurant.jpg", "emma_food.jpg"].to_json
  },
  {
    email: "frank@example.com",
    username: "frank_comedy",
    first_name: "Frank",
    last_name: "Miller",
    bio: "Stand-up comedy fan and aspiring comedian. Love a good laugh and meeting funny people! Life's too short not to laugh every day! 😂",
    password: "password123",
    date_of_birth: Date.new(1988, 12, 20),
    city: "Seattle",
    interests: select_interests_for_user(:comedian),
    occupation: "Marketing Manager",
    education: "University of Washington - Communications",
    height: "5'9\"",
    photos: ["frank_main.jpg", "frank_comedy.jpg", "frank_friends.jpg", "frank_seattle.jpg"].to_json
  },
  {
    email: "grace@example.com",
    username: "grace_books",
    first_name: "Grace",
    last_name: "Taylor",
    bio: "Bookworm and literature enthusiast. Love book readings and literary events. English teacher with a passion for poetry and classic novels! 📚",
    password: "password123",
    date_of_birth: Date.new(1993, 4, 7),
    city: "Boston",
    interests: select_interests_for_user(:teacher),
    occupation: "English Teacher",
    education: "Harvard University - English Literature",
    height: "5'3\"",
    photos: ["grace_main.jpg", "grace_books.jpg", "grace_coffee.jpg", "grace_teaching.jpg"].to_json
  },
  {
    email: "henry@example.com",
    username: "henry_dance",
    first_name: "Henry",
    last_name: "Anderson",
    bio: "Dance lover and salsa instructor. Always ready to hit the dance floor! Professional dancer who loves teaching others the joy of movement! 💃",
    password: "password123",
    date_of_birth: Date.new(1991, 8, 14),
    city: "Miami",
    interests: select_interests_for_user(:dancer),
    occupation: "Dance Instructor",
    education: "Florida International University - Performing Arts",
    height: "5'10\"",
    photos: ["henry_main.jpg", "henry_dancing.jpg", "henry_beach.jpg", "henry_performance.jpg"].to_json
  },
  {
    email: "isabella@example.com",
    username: "isabella_photo",
    first_name: "Isabella",
    last_name: "Garcia",
    bio: "Photography enthusiast and nature lover. Always capturing beautiful moments! Freelance photographer with an eye for adventure and natural beauty! 📸",
    password: "password123",
    date_of_birth: Date.new(1997, 2, 28),
    city: "Denver",
    interests: select_interests_for_user(:photographer),
    occupation: "Photographer",
    education: "Art Institute of Colorado - Photography",
    height: "5'7\"",
    photos: ["isabella_main.jpg", "isabella_mountains.jpg", "isabella_camera.jpg", "isabella_nature.jpg"].to_json
  },
  {
    email: "jack@example.com",
    username: "jack_outdoor",
    first_name: "Jack",
    last_name: "Thompson",
    bio: "Adventure seeker and outdoor enthusiast. Love hiking, camping, and festivals! Rock climbing instructor who lives for the next adventure! 🧗‍♂️",
    password: "password123",
    date_of_birth: Date.new(1989, 6, 11),
    city: "Portland",
    interests: select_interests_for_user(:outdoor_guide),
    occupation: "Outdoor Guide",
    education: "Oregon State University - Recreation",
    height: "6'0\"",
    photos: ["jack_main.jpg", "jack_climbing.jpg", "jack_hiking.jpg", "jack_festival.jpg"].to_json
  }
]

created_users = users_data.map do |user_data|
  User.create!(user_data)
end

puts "✅ Created #{created_users.count} users with rich profiles"
puts "📋 Available interests: #{User::AVAILABLE_INTERESTS.count} options"

# Store users in a global variable for other seed files
$seed_users = created_users 