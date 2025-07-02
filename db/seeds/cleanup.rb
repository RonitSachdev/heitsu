# Clear existing data in development
if Rails.env.development?
  puts "🧹 Cleaning up existing data..."
  
  # Clean up in reverse dependency order
  Message.destroy_all
  UserMatch.destroy_all
  UserSwipe.destroy_all
  EventRegistration.destroy_all
  Event.destroy_all
  User.destroy_all
  
  puts "✅ Cleanup completed"
else
  puts "⚠️  Skipping cleanup - not in development environment"
end 