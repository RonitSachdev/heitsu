# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   genre = Genre.find_or_create_by(name: "Fantasy")
#   movies.first.update(genre: genre)

puts "🌱 Starting heitsu database seeding..."
puts "=" * 50

# Load seed files in the correct order due to dependencies
seed_files = [
  'cleanup',
  'users',
  'events', 
  'event_registrations',
  'user_swipes_and_matches',
  'messages'
]

seed_files.each do |seed_file|
  puts "\n🔄 Loading #{seed_file}..."
  load Rails.root.join('db', 'seeds', "#{seed_file}.rb")
end

# Print final summary
puts "\n🎉 Seeding completed successfully!"
puts "=" * 50
puts "📊 Final Summary:"
puts "👥 Users: #{User.count}"
puts "🎉 Events: #{Event.count}"
puts "📝 Event Registrations: #{EventRegistration.count}"
puts "👆 User Swipes: #{UserSwipe.count}"
puts "💝 User Matches: #{UserMatch.count}"
puts "💬 Messages: #{Message.count}"
puts "=" * 50
puts "🚀 Your heitsu app is ready with comprehensive test data!"
puts "💡 All users have password: 'password123'"
puts "📧 Login with emails like: alice@example.com, bob@example.com, carol@example.com..."
puts "🎯 Users are registered for multiple events with matches and active conversations!"
