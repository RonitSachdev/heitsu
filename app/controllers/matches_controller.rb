class MatchesController < ApplicationController
  before_action :set_match, only: [:show]

  def index
    @matches = current_user.matches.includes(:user1, :user2, :event).order(created_at: :desc)
    
    # Find matches that have messages by checking if messages exist between the users
    matches_with_messages_ids = []
    @message_counts = {}
    
    @matches.each do |match|
      other_user = match.other_user(current_user)
      message_count = Message.between_users(current_user, other_user).count
      
      if message_count > 0
        matches_with_messages_ids << match.id
        @message_counts[match.id] = message_count
      end
    end
    
    @matches_with_messages = @matches.where(id: matches_with_messages_ids)
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