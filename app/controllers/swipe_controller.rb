class SwipeController < ApplicationController
  def index
    @registered_events = current_user.events.upcoming
  end

  def event
    @event = Event.find(params[:event_id])

    unless current_user.registered_for_event?(@event)
      flash[:alert] = "You must be registered for this event to start swiping"
      redirect_to @event and return
    end

    @users_to_swipe = current_user.users_to_swipe_for_event(@event).limit(10)
    @current_user_json = current_user.to_json(only: [ :id, :first_name ])
  end

  def swipe_user
    swiped_user = User.find(params[:swiped_user_id])
    event = Event.find(params[:event_id])
    direction = params[:direction]

    # Validate that both users are registered for the event
    unless current_user.registered_for_event?(event)
      render json: { error: "You must be registered for this event" }, status: :forbidden
      return
    end

    unless swiped_user.registered_for_event?(event)
      render json: { error: "User is not registered for this event" }, status: :forbidden
      return
    end

    # Create the swipe
    swipe = UserSwipe.create!(
      swiper: current_user,
      swiped_user: swiped_user,
      event: event,
      direction: direction
    )

    # Check for match if this was a right swipe
    match_data = nil
    if direction == "right"
      # Check if the other user also swiped right
      other_swipe = UserSwipe.find_by(
        swiper: swiped_user,
        swiped_user: current_user,
        event: event,
        direction: "right"
      )

      if other_swipe
        # Create match (ensure user1_id < user2_id)
        user1, user2 = [ current_user, swiped_user ].sort_by(&:id)
        match = UserMatch.find_or_create_by!(
          user1: user1,
          user2: user2,
          event: event
        )

        match_data = {
          match: true,
          user: {
            id: swiped_user.id,
            name: swiped_user.full_name,
            username: swiped_user.username
          }
        }
      end
    end

    if match_data
      render json: match_data
    else
      render json: { success: true }
    end
  end
end
