puts "💝 Creating user swipes and matches..."

swipe_count = 0
match_count = 0

$seed_events.each do |event|
  event_users = event.users.to_a
  next if event_users.count < 2

  # Create some swipes between users registered for the same event
  event_users.each do |swiper|
    # Each user swipes on 2-4 other users at the event
    other_users = event_users - [ swiper ]
    swiped_users = other_users.sample(rand(2..4))

    swiped_users.each do |swiped_user|
      # Avoid duplicate swipes
      unless UserSwipe.exists?(swiper: swiper, swiped_user: swiped_user, event: event)
        # Higher probability of right swipes to create more matches
        direction = rand < 0.7 ? 'right' : 'left'
        swipe_time = rand(1..7).days.ago

        UserSwipe.create!(
          swiper: swiper,
          swiped_user: swiped_user,
          event: event,
          direction: direction,
          created_at: swipe_time,
          updated_at: swipe_time
        )
        swipe_count += 1

        # Check if this creates a match (both users swiped right on each other)
        if direction == 'right'
          reverse_swipe = UserSwipe.find_by(
            swiper: swiped_user,
            swiped_user: swiper,
            event: event,
            direction: 'right'
          )

          if reverse_swipe && !UserMatch.exists?(user1: swiper, user2: swiped_user, event: event) && !UserMatch.exists?(user1: swiped_user, user2: swiper, event: event)
            # Ensure user1_id is always smaller than user2_id for consistency
            user1, user2 = [ swiper, swiped_user ].sort_by(&:id)
            match_time = [ reverse_swipe.created_at, swipe_time ].max

            UserMatch.create!(
              user1: user1,
              user2: user2,
              event: event,
              created_at: match_time,
              updated_at: match_time
            )
            match_count += 1
          end
        end
      end
    end
  end
end

puts "✅ Created #{swipe_count} user swipes and #{match_count} matches"
