puts "👆 Creating group swipes..."

group_swipe_count = 0

$seed_events.each do |event|
  event_users = event.users.to_a
  event_groups = event.groups.to_a
  
  next if event_users.empty? || event_groups.empty?
  
  # Users swipe on groups they're not already in
  event_users.each do |user|
    user_groups = user.groups.where(event: event).to_a
    available_groups = event_groups - user_groups
    
    # Each user swipes on 1-3 available groups
    groups_to_swipe = available_groups.sample(rand(1..3))
    
    groups_to_swipe.each do |group|
      unless GroupSwipe.exists?(swiper: user, group: group)
        # Higher probability of right swipes for groups
        direction = rand < 0.75 ? 'right' : 'left'
        swipe_time = rand(1..5).days.ago
        
        GroupSwipe.create!(
          swiper: user,
          group: group,
          direction: direction,
          created_at: swipe_time,
          updated_at: swipe_time
        )
        group_swipe_count += 1
      end
    end
  end
end

puts "✅ Created #{group_swipe_count} group swipes" 