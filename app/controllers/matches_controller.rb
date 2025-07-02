class MatchesController < ApplicationController
  before_action :set_match, only: [ :show ]

  def index
    @matches = current_user.matches.includes(:user1, :user2, :event).order(created_at: :desc)

    # Process matches with messaging data
    matches_with_messages_ids = []
    @matches_data = {}

    @matches.each do |match|
      other_user = match.other_user(current_user)

      # Get unread messages count for this match
      unread_count = Message.between_users(current_user, other_user)
                           .where(recipient: current_user, read_at: nil)
                           .count

      # Get the most recent message for this match
      recent_message = Message.between_users(current_user, other_user)
                             .order(created_at: :desc)
                             .first

      # Store match data
      @matches_data[match.id] = {
        unread_count: unread_count,
        recent_message: recent_message,
        has_messages: recent_message.present?
      }

      if recent_message.present?
        matches_with_messages_ids << match.id
      end
    end

    @matches_with_messages = @matches.where(id: matches_with_messages_ids)
                                   .sort_by { |match| -(@matches_data[match.id][:unread_count]) }
    @matches_without_messages = @matches.where.not(id: matches_with_messages_ids)
  end

  def show
    @other_user = @match.other_user(current_user)
    @messages = Message.conversation_between(current_user, @other_user)
    @new_message = Message.new

    # Mark messages as read
    Message.between_users(current_user, @other_user)
           .where(recipient: current_user)
           .where(read_at: nil)
           .update_all(read_at: Time.current)
  end

  private

  def set_match
    @match = current_user.matches.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "Match not found"
    redirect_to matches_path
  end
end
