class UserSwipe < ApplicationRecord
  belongs_to :swiper, class_name: "User"
  belongs_to :swiped_user, class_name: "User"
  belongs_to :event

  # Validations
  validates :direction, presence: true, inclusion: { in: %w[left right] }
  validates :swiper_id, uniqueness: { scope: [ :swiped_user_id, :event_id ] }
  validate :cannot_swipe_on_self
  validate :both_users_must_be_registered

  # Callbacks
  after_create :check_for_match, if: :right_swipe?

  # Scopes
  scope :right_swipes, -> { where(direction: "right") }
  scope :left_swipes, -> { where(direction: "left") }

  private

  def right_swipe?
    direction == "right"
  end

  def cannot_swipe_on_self
    errors.add(:swiped_user, "can't swipe on yourself") if swiper_id == swiped_user_id
  end

  def both_users_must_be_registered
    unless swiper.registered_for_event?(event)
      errors.add(:swiper, "must be registered for this event")
    end

    unless swiped_user.registered_for_event?(event)
      errors.add(:swiped_user, "must be registered for this event")
    end
  end

  def check_for_match
    # Check if the swiped user has also swiped right on the swiper
    mutual_swipe = UserSwipe.find_by(
      swiper: swiped_user,
      swiped_user: swiper,
      event: event,
      direction: "right"
    )

    if mutual_swipe
      create_match
    end
  end

  def create_match
    # Ensure user1_id is always the smaller ID for consistency
    user1, user2 = [ swiper_id, swiped_user_id ].sort

    UserMatch.find_or_create_by(
      user1_id: user1,
      user2_id: user2,
      event: event
    )
  end
end
