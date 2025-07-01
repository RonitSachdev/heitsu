puts "🎉 Creating events..."

events_data = [
  {
    title: "Summer Music Festival 2024",
    description: "Three days of amazing music with top artists from around the world. Food trucks, art installations, and great vibes!",
    location: "Central Park, New York",
    event_date: 2.months.from_now,
    category: "Music",
    max_attendees: 500
  },
  {
    title: "Tech Innovation Conference",
    description: "Join industry leaders and innovators for talks on AI, blockchain, and the future of technology.",
    location: "Convention Center, San Francisco",
    event_date: 1.month.from_now,
    category: "Technology",
    max_attendees: 200
  },
  {
    title: "Contemporary Art Gallery Opening",
    description: "Exclusive opening of the new contemporary art exhibition featuring local and international artists.",
    location: "Modern Art Museum, Los Angeles",
    event_date: 3.weeks.from_now,
    category: "Art",
    max_attendees: 150
  },
  {
    title: "Marathon Training Meetup",
    description: "Join fellow runners for a group training session and motivational talks from marathon champions.",
    location: "Riverside Park, Chicago",
    event_date: 2.weeks.from_now,
    category: "Sports",
    max_attendees: 100
  },
  {
    title: "Food & Wine Festival",
    description: "Taste amazing dishes from top chefs and pair them with fine wines from around the world.",
    location: "Harbor Front, Seattle",
    event_date: 5.weeks.from_now,
    category: "Food",
    max_attendees: 300
  },
  {
    title: "Comedy Night Spectacular",
    description: "An evening of laughs with renowned stand-up comedians and rising stars.",
    location: "Comedy Club, Austin",
    event_date: 10.days.from_now,
    category: "Comedy",
    max_attendees: 80
  },
  {
    title: "Book Fair & Author Readings",
    description: "Meet your favorite authors, discover new books, and enjoy live readings and discussions.",
    location: "Public Library, Boston",
    event_date: 4.weeks.from_now,
    category: "Literature",
    max_attendees: 120
  },
  {
    title: "Salsa Dance Workshop",
    description: "Learn salsa dancing from professional instructors and enjoy a night of dancing and music.",
    location: "Dance Studio, Miami",
    event_date: 1.week.from_now,
    category: "Dance",
    max_attendees: 60
  },
  {
    title: "Photography Workshop & Nature Walk",
    description: "Learn photography techniques while exploring beautiful nature spots with professional photographers.",
    location: "Golden Gate Park, San Francisco",
    event_date: 3.weeks.from_now,
    category: "Photography",
    max_attendees: 40
  },
  {
    title: "Outdoor Adventure & Camping Festival",
    description: "Weekend camping with hiking, rock climbing, and outdoor activities for adventure enthusiasts.",
    location: "Yosemite National Park, California",
    event_date: 6.weeks.from_now,
    category: "Outdoor",
    max_attendees: 75
  }
]

created_events = events_data.map do |event_data|
  Event.create!(event_data)
end

puts "✅ Created #{created_events.count} events"

# Store events in a global variable for other seed files
$seed_events = created_events 