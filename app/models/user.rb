class User < ApplicationRecord
  has_secure_password

  # Event relationships
  has_many :event_registrations, dependent: :destroy
  has_many :events, through: :event_registrations

  # User swiping relationships
  has_many :user_swipes, foreign_key: 'swiper_id', dependent: :destroy
  has_many :received_swipes, class_name: 'UserSwipe', foreign_key: 'swiped_user_id', dependent: :destroy
  
  # Match relationships
  has_many :matches_as_user1, class_name: 'UserMatch', foreign_key: 'user1_id', dependent: :destroy
  has_many :matches_as_user2, class_name: 'UserMatch', foreign_key: 'user2_id', dependent: :destroy
  
  # Group relationships
  has_many :created_groups, class_name: 'Group', foreign_key: 'creator_id', dependent: :destroy
  has_many :group_members, dependent: :destroy
  has_many :groups, through: :group_members
  has_many :group_swipes, foreign_key: 'swiper_id', dependent: :destroy
  has_many :group_join_requests, dependent: :destroy

  # Message relationships
  has_many :sent_messages, class_name: 'Message', foreign_key: 'sender_id', dependent: :destroy
  has_many :received_messages, class_name: 'Message', foreign_key: 'recipient_id', dependent: :destroy

  # Validations
  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true

  # Methods to get all matches
  def matches
    UserMatch.where("user1_id = ? OR user2_id = ?", id, id)
  end

  # Get matched users
  def matched_users
    match_ids = matches.pluck(:user1_id, :user2_id).flatten.uniq - [id]
    User.where(id: match_ids)
  end

  # Check if user is registered for an event
  def registered_for_event?(event)
    event_registrations.exists?(event: event)
  end

  # Get users to swipe on for a specific event
  def users_to_swipe_for_event(event)
    return User.none unless registered_for_event?(event)
    
    # Get users registered for the same event
    registered_users = event.users.where.not(id: id)
    
    # Exclude users already swiped on
    already_swiped_ids = user_swipes.where(event: event).pluck(:swiped_user_id)
    
    registered_users.where.not(id: already_swiped_ids)
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end