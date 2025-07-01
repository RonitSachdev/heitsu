puts "👥 Creating groups..."

groups_data = [
  {
    name: "Music Lovers United",
    description: "For those who want to experience the festival together and discover new music!",
    max_members: 8
  },
  {
    name: "Tech Entrepreneurs",
    description: "Networking group for startup founders and tech entrepreneurs at the conference.",
    max_members: 6
  },
  {
    name: "Art Enthusiasts",
    description: "Let's explore the gallery together and discuss the amazing artworks!",
    max_members: 5
  },
  {
    name: "Running Buddies",
    description: "Training partners for the marathon. Let's motivate each other!",
    max_members: 10
  },
  {
    name: "Foodies Paradise",
    description: "For serious food lovers who want to try everything at the festival!",
    max_members: 7
  },
  {
    name: "Comedy Squad",
    description: "Let's laugh together and maybe grab drinks after the show!",
    max_members: 6
  },
  {
    name: "Book Club Extended",
    description: "Book lovers who want to meet authors and discuss literature in person!",
    max_members: 8
  },
  {
    name: "Dance Floor Kings & Queens",
    description: "Experienced dancers and beginners welcome! Let's salsa the night away!",
    max_members: 12
  },
  {
    name: "Photography Enthusiasts",
    description: "Capture beautiful moments together and share photography tips!",
    max_members: 6
  },
  {
    name: "Adventure Seekers",
    description: "For the brave souls ready to conquer the outdoors together!",
    max_members: 8
  }
]

created_groups = []
groups_data.each_with_index do |group_data, index|
  event = $seed_events[index]
  # Select a creator from users registered for this event
  creator = event.users.sample
  
  group_time = rand(1..14).days.ago
  
  group = Group.create!(
    name: group_data[:name],
    description: group_data[:description],
    event: event,
    creator: creator,
    max_members: group_data[:max_members],
    created_at: group_time,
    updated_at: group_time
  )
  created_groups << group
end

puts "✅ Created #{created_groups.count} groups"

# Store groups in a global variable for other seed files
$seed_groups = created_groups 