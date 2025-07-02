puts "💬 Creating messages..."

message_count = 0

# Create direct messages between matched users
UserMatch.includes(:user1, :user2).each do |match|
  # Create 3-6 messages between matched users
  rand(3..6).times do |i|
    sender = [match.user1, match.user2].sample
    recipient = sender == match.user1 ? match.user2 : match.user1
    
    direct_messages = [
      "Hey! Great to match with you at #{match.event.title}!",
      "Looking forward to the event! Have you been to something like this before?",
      "Your profile says you love #{match.event.category.downcase} - me too!",
      "Want to meet up before the event starts?",
      "This is going to be amazing! Can't wait!",
      "Thanks for the right swipe! 😊",
      "Hope to see you there!",
      "Are you planning to stay for the whole event?",
      "Maybe we can grab some food together?",
      "Your bio is really interesting!",
      "I love your taste in #{match.event.category.downcase} events!",
      "Should we coordinate our arrival time?",
      "This event is going to be epic!",
      "Nice to connect with someone who shares similar interests!",
      "Looking forward to meeting you in person!"
    ]
    
    message_time = rand(1..5).days.ago
    
    Message.create!(
      sender: sender,
      recipient: recipient,
      content: direct_messages.sample,
      message_type: 'direct',
      created_at: message_time,
      updated_at: message_time
    )
    message_count += 1
  end
end

puts "✅ Created #{message_count} messages" 