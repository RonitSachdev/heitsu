class UserMatch < ApplicationRecord
  belongs_to :user1, class_name: "User"
  belongs_to :user2, class_name: "User"
  belongs_to :event

  # Validations
  validates :user1_id, uniqueness: { scope: [ :user2_id, :event_id ] }
  validate :users_must_be_different
  validate :both_users_registered_for_event
  validate :user1_id_smaller_than_user2_id

  # Methods
  def users
    [ user1, user2 ]
  end

  def other_user(current_user)
    return user2 if current_user == user1
    return user1 if current_user == user2
    nil
  end

  def includes_user?(user)
    user1 == user || user2 == user
  end

  # Get messages between the matched users
  def messages
    Message.between_users(user1, user2)
  end

  # Check if match exists between two users for an event
  def self.exists_between?(user_a, user_b, event)
    user1, user2 = [ user_a.id, user_b.id ].sort
    exists?(user1_id: user1, user2_id: user2, event: event)
  end

  private

  def users_must_be_different
    errors.add(:user2, "cannot match with yourself") if user1_id == user2_id
  end

  def both_users_registered_for_event
    unless user1&.registered_for_event?(event)
      errors.add(:user1, "must be registered for this event")
    end

    unless user2&.registered_for_event?(event)
      errors.add(:user2, "must be registered for this event")
    end
  end

  def user1_id_smaller_than_user2_id
    return unless user1_id && user2_id

    if user1_id > user2_id
      errors.add(:base, "user1_id must be smaller than user2_id")
    end
  end
end
