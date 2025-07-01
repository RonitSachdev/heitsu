puts "👥 Creating users..."

users_data = [
  {
    email: "alice@example.com",
    username: "alice_music",
    first_name: "Alice",
    last_name: "Johnson",
    bio: "Music lover and concert enthusiast. Always looking for new bands to discover!",
    password: "password123"
  },
  {
    email: "bob@example.com",
    username: "bob_techie",
    first_name: "Bob",
    last_name: "Smith",
    bio: "Tech conference addict. Love networking and learning about new technologies.",
    password: "password123"
  },
  {
    email: "carol@example.com",
    username: "carol_artist",
    first_name: "Carol",
    last_name: "Davis",
    bio: "Art gallery enthusiast and painter. Always up for cultural events!",
    password: "password123"
  },
  {
    email: "david@example.com",
    username: "david_sports",
    first_name: "David",
    last_name: "Wilson",
    bio: "Sports fan and marathon runner. Love attending live sports events.",
    password: "password123"
  },
  {
    email: "emma@example.com",
    username: "emma_foodie",
    first_name: "Emma",
    last_name: "Brown",
    bio: "Food lover and cooking enthusiast. Always hunting for the best food festivals!",
    password: "password123"
  },
  {
    email: "frank@example.com",
    username: "frank_comedy",
    first_name: "Frank",
    last_name: "Miller",
    bio: "Stand-up comedy fan. Love a good laugh and meeting funny people!",
    password: "password123"
  },
  {
    email: "grace@example.com",
    username: "grace_books",
    first_name: "Grace",
    last_name: "Taylor",
    bio: "Bookworm and literature enthusiast. Love book readings and literary events.",
    password: "password123"
  },
  {
    email: "henry@example.com",
    username: "henry_dance",
    first_name: "Henry",
    last_name: "Anderson",
    bio: "Dance lover and salsa instructor. Always ready to hit the dance floor!",
    password: "password123"
  },
  {
    email: "isabella@example.com",
    username: "isabella_photo",
    first_name: "Isabella",
    last_name: "Garcia",
    bio: "Photography enthusiast and nature lover. Always capturing beautiful moments!",
    password: "password123"
  },
  {
    email: "jack@example.com",
    username: "jack_outdoor",
    first_name: "Jack",
    last_name: "Thompson",
    bio: "Adventure seeker and outdoor enthusiast. Love hiking, camping, and festivals!",
    password: "password123"
  }
]

created_users = users_data.map do |user_data|
  User.create!(user_data)
end

puts "✅ Created #{created_users.count} users"

# Store users in a global variable for other seed files
$seed_users = created_users 