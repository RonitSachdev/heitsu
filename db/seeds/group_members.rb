puts "👥 Creating group members..."

member_count = 0

$seed_groups.each do |group|
  # Add creator as admin (only if not already a member)
  unless GroupMember.exists?(group: group, user: group.creator)
    GroupMember.create!(
      group: group,
      user: group.creator,
      role: 'admin',
      created_at: group.created_at,
      updated_at: group.created_at
    )
    member_count += 1
  end
  
  # Add 3-5 other members from users registered for the same event
  available_users = group.event.users.where.not(id: group.creator.id)
  members_to_add = available_users.sample(rand(3..5))
  
  members_to_add.each do |user|
    # Double-check to avoid duplicate memberships
    unless GroupMember.exists?(group: group, user: user)
      join_time = rand(1..10).days.ago
      
      GroupMember.create!(
        group: group,
        user: user,
        role: 'member',
        created_at: join_time,
        updated_at: join_time
      )
      member_count += 1
    end
  end
end

puts "✅ Created #{member_count} group members" 