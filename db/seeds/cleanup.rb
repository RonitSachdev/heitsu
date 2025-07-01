# Clear existing data in development
if Rails.env.development?
  puts "🧹 Cleaning up existing data..."
  
  # Order matters due to foreign key constraints
  Message.destroy_all
  GroupJoinRequest.destroy_all
  GroupSwipe.destroy_all
  GroupMember.destroy_all
  Group.destroy_all
  UserMatch.destroy_all
  UserSwipe.destroy_all
  EventRegistration.destroy_all
  Event.destroy_all
  User.destroy_all
  
  puts "✅ Cleanup complete!"
else
  puts "⚠️  Skipping cleanup - not in development environment"
end 