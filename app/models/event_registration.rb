class EventRegistration < ApplicationRecord
  belongs_to :user
  belongs_to :event

  # Validations
  validates :status, presence: true, inclusion: { in: %w[registered cancelled] }
  validates :user_id, uniqueness: { scope: :event_id }
  validate :event_not_full
  validate :event_not_past

  # Scopes
  scope :active, -> { where(status: 'registered') }
  scope :cancelled, -> { where(status: 'cancelled') }

  # Methods
  def cancel!
    update!(status: 'cancelled')
  end

  def active?
    status == 'registered'
  end

  def cancelled?
    status == 'cancelled'
  end

  # Set default status
  after_initialize :set_default_status, if: :new_record?

  private

  def set_default_status
    self.status ||= 'registered'
  end

  def event_not_full
    return unless event&.full? && status == 'registered'
    
    errors.add(:event, "is full")
  end

  def event_not_past
    return unless event&.past?
    
    errors.add(:event, "has already passed")
  end
end
