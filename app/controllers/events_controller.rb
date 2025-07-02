class EventsController < ApplicationController
  before_action :set_event, only: [:show, :register, :unregister]

  def index
    @events = Event.upcoming.includes(:event_registrations)
    @events = @events.by_category(params[:category]) if params[:category].present?
    
    @categories = Event.distinct.pluck(:category).compact.sort
    @user_registered_events = current_user.events.pluck(:id)
  end

  def show
    @is_registered = current_user.registered_for_event?(@event)
    @attendees = @event.users.limit(12)
  end

  def register
    if @event.full?
      flash[:alert] = "Sorry, this event is full!"
    elsif @event.past?
      flash[:alert] = "Cannot register for past events"
    elsif @event.user_registered?(current_user)
      flash[:alert] = "You are already registered for this event"
    else
      EventRegistration.create!(user: current_user, event: @event)
      flash[:notice] = "Successfully registered for #{@event.title}!"
    end
    
    redirect_to @event
  end

  def unregister
    registration = EventRegistration.find_by(user: current_user, event: @event)
    
    if registration
      registration.update!(status: 'cancelled')
      flash[:notice] = "Unregistered from #{@event.title}"
    else
      flash[:alert] = "You are not registered for this event"
    end
    
    redirect_to @event
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end
end 