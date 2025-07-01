class GroupSwipe < ApplicationRecord
  belongs_to :swiper, class_name: 'User'
  belongs_to :group

  # Validations
  validates :direction, presence: true, inclusion: { in: %w[left right] }
  validates :swiper_id, uniqueness: { scope: :group_id }
  validate :swiper_must_be_registered_for_event
  validate :cannot_swipe_on_own_group

  # Callbacks
  after_create :handle_right_swipe, if: :right_swipe?

  # Scopes
  scope :right_swipes, -> { where(direction: 'right') }
  scope :left_swipes, -> { where(direction: 'left') }

  private

  def right_swipe?
    direction == 'right'
  end

  def swiper_must_be_registered_for_event
    unless swiper.registered_for_event?(group.event)
      errors.add(:swiper, "must be registered for this event")
    end
  end

  def cannot_swipe_on_own_group
    if group.creator == swiper
      errors.add(:group, "cannot swipe on your own group")
    end
  end

  def handle_right_swipe
    # Check if group has available spots for auto-join
    if group.can_join?(swiper)
      # Auto-join if there's space
      group.join_user!(swiper)
    else
      # Create join request if group is full
      GroupJoinRequest.find_or_create_by(
        user: swiper,
        group: group
      ) do |request|
        request.status = 'pending'
        request.message = "Requested to join via swipe"
      end
    end
  end
end
