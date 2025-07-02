class MessagesController < ApplicationController
  def create
    @message = Message.new(message_params)
    @message.sender = current_user

    # Validate permissions for direct messages
    unless can_message_user?(@message.recipient)
      respond_to do |format|
        format.html do
          flash[:alert] = "You can only message users you've matched with"
          redirect_back_or_to matches_path
        end
        format.json do
          render json: { success: false, error: "You can only message users you've matched with" }, status: :forbidden
        end
        format.all do
          render json: { success: false, error: "You can only message users you've matched with" }, status: :forbidden
        end
      end
      return
    end

    if @message.save
      respond_to do |format|
        format.html do
          flash[:notice] = "Message sent!"
          # Find the match to redirect back to
          match = UserMatch.where(
            "(user1_id = ? AND user2_id = ?) OR (user1_id = ? AND user2_id = ?)",
            current_user.id, @message.recipient.id, @message.recipient.id, current_user.id
          ).first
          redirect_to match_path(match)
        end
        
        format.json do
          render json: {
            success: true,
            id: @message.id,
            content: @message.content,
            sender: {
              id: @message.sender.id,
              name: @message.sender.full_name,
              username: @message.sender.username
            },
            created_at: @message.created_at.strftime('%I:%M %p')
          }
        end
        
        # Default to JSON if no specific format requested (for AJAX requests)
        format.all do
          render json: {
            success: true,
            id: @message.id,
            content: @message.content,
            sender: {
              id: @message.sender.id,
              name: @message.sender.full_name,
              username: @message.sender.username
            },
            created_at: @message.created_at.strftime('%I:%M %p')
          }
        end
      end
    else
      respond_to do |format|
        format.html do
          flash[:alert] = @message.errors.full_messages.join(', ')
          redirect_back_or_to matches_path
        end
        
        format.json do
          render json: { success: false, errors: @message.errors.full_messages }, status: :unprocessable_entity
        end
        
        # Default to JSON for AJAX requests
        format.all do
          render json: { success: false, errors: @message.errors.full_messages }, status: :unprocessable_entity
        end
      end
    end
  end

  private

  def message_params
    params.require(:message).permit(:content, :message_type, :recipient_id)
  end

  def can_message_user?(recipient)
    return false unless recipient
    
    # Check if users have matched
    UserMatch.where(
      "(user1_id = ? AND user2_id = ?) OR (user1_id = ? AND user2_id = ?)",
      current_user.id, recipient.id, recipient.id, current_user.id
    ).exists?
  end

  def redirect_back_or_to(fallback_location)
    redirect_to(request.referer || fallback_location)
  end
end 