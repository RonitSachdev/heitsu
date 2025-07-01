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

# Create group messages
$seed_groups.each do |group|
  group_members = group.group_members.includes(:user)
  
  # Create 4-10 group messages
  rand(4..10).times do |i|
    sender = group_members.sample.user
    
    group_messages = [
      "Excited to meet everyone at #{group.event.title}!",
      "Should we plan to meet at a specific location?",
      "This group is going to make the event even better!",
      "Looking forward to hanging out with you all!",
      "Anyone have recommendations for what to see first?",
      "Can't wait for this event!",
      "Great group description - exactly what I was looking for!",
      "Thanks for accepting me into the group!",
      "This is going to be so much fun!",
      "Perfect group size for a great time!",
      "Has anyone been to #{group.event.location} before?",
      "We should definitely stick together during the event!",
      "I'm bringing some snacks to share with the group!",
      "Anyone interested in carpooling to the venue?",
      "This group has such great energy already!",
      "Looking forward to making new friends!",
      "The event is getting closer - so excited!",
      "Thanks #{group.creator.first_name} for creating this awesome group!",
      "Anyone else counting down the days?",
      "This is exactly the kind of group I was hoping to find!"
    ]
    
    message_time = rand(1..7).days.ago
    
    Message.create!(
      sender: sender,
      group: group,
      content: group_messages.sample,
      message_type: 'group',
      created_at: message_time,
      updated_at: message_time
    )
    message_count += 1
  end
end

puts "✅ Created #{message_count} messages" 