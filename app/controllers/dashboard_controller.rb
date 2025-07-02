class DashboardController < ApplicationController
  def index
    @user = current_user
    
    # Ensure we have arrays by converting ActiveRecord relations to arrays
    @upcoming_events = @user.events.upcoming.limit(3).to_a
    @recent_matches = @user.matches.includes(:user1, :user2).order(created_at: :desc).limit(5).to_a
    @unread_messages_count = Message.where(recipient: @user).where(read_at: nil).count
    
    # Stats for dashboard
    @stats = {
      registered_events: @user.events.count,
      total_matches: @user.matches.count,
      unread_messages: @unread_messages_count
    }
  end
end 