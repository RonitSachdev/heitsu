puts "📨 Creating group join requests..."

join_request_count = 0

$seed_groups.each do |group|
  # Create 1-3 join requests for groups that have available spots
  if group.group_members.count < group.max_members
    available_users = group.event.users.where.not(id: group.group_members.pluck(:user_id))
    users_requesting = available_users.sample(rand(1..3))
    
    users_requesting.each do |user|
      unless GroupJoinRequest.exists?(group: group, user: user)
        status = ['pending', 'approved', 'rejected'].sample
        request_time = rand(1..5).days.ago
        
        join_request = GroupJoinRequest.create!(
          group: group,
          user: user,
          status: status,
          created_at: request_time,
          updated_at: status == 'pending' ? request_time : request_time + rand(1..48).hours
        )
        
        join_request_count += 1
      end
    end
  end
end

puts "✅ Created #{join_request_count} group join requests" 