puts "📝 Creating event registrations..."

registration_count = 0

$seed_events.each do |event|
  # Register 4-7 random users for each event
  registered_users = $seed_users.sample(rand(4..7))
  
  registered_users.each do |user|
    EventRegistration.create!(
      user: user,
      event: event,
      status: 'registered', # Only 'registered' or 'cancelled' are valid
      created_at: rand(1..30).days.ago,
      updated_at: rand(1..30).days.ago
    )
    registration_count += 1
  end
end

puts "✅ Created #{registration_count} event registrations" 