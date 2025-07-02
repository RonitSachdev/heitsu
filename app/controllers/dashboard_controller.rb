class DashboardController < ApplicationController
  def index
    @user = current_user

    # Ensure we have arrays by converting ActiveRecord relations to arrays
    @upcoming_events = @user.events.upcoming.limit(3).to_a
    raw_matches = @user.matches.includes(:user1, :user2, :event).order(created_at: :desc).limit(5).to_a

    # Get message data for each match
    @recent_matches = []
    raw_matches.each do |match|
      other_user = match.other_user(current_user)

      # Get unread messages count for this match
      unread_count = Message.between_users(current_user, other_user)
                           .where(recipient: current_user, read_at: nil)
                           .count

      # Get the most recent message for this match
      recent_message = Message.between_users(current_user, other_user)
                             .order(created_at: :desc)
                             .first

      # Add match data with messaging info
      match_data = {
        match: match,
        other_user: other_user,
        unread_count: unread_count,
        recent_message: recent_message
      }

      @recent_matches << match_data
    end

    # Sort matches - those with unread messages first, then by recent message date
    @recent_matches.sort_by! do |match_data|
      [
        -match_data[:unread_count], # Negative for descending (more unread first)
        -(match_data[:recent_message]&.created_at&.to_i || 0) # Most recent messages first
      ]
    end

    @unread_messages_count = Message.where(recipient: @user).where(read_at: nil).count

    # Stats for dashboard
    @stats = {
      registered_events: @user.events.count,
      total_matches: @user.matches.count,
      unread_messages: @unread_messages_count
    }
  end
end
