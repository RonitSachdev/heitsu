class Event < ApplicationRecord
  # User relationships
  has_many :event_registrations, dependent: :destroy
  has_many :users, through: :event_registrations

  # Swiping and matching relationships
  has_many :user_swipes, dependent: :destroy
  has_many :user_matches, dependent: :destroy

  # Validations
  validates :title, presence: true
  validates :description, presence: true
  validates :location, presence: true
  validates :event_date, presence: true
  validates :category, presence: true
  validates :max_attendees, presence: true, numericality: { greater_than: 0 }
  validate :event_date_cannot_be_in_past

  # Scopes
  scope :upcoming, -> { where("event_date > ?", Time.current) }
  scope :past, -> { where("event_date <= ?", Time.current) }
  scope :recent, -> { order(created_at: :desc) }
  scope :by_category, ->(category) { where(category: category) if category.present? }
  scope :with_available_spots, -> { joins(:event_registrations).group("events.id").having("COUNT(event_registrations.id) < events.max_attendees") }
  scope :by_location, ->(location) { where("location ILIKE ?", "%#{location}%") }

  # Methods
  def full?
    registered_users_count >= max_attendees
  end

  def available_spots
    max_attendees - registered_users_count
  end

  def past?
    event_date <= Time.current
  end

  def upcoming?
    event_date > Time.current
  end

  def registered_users_count
    event_registrations.active.count
  end

  def user_registered?(user)
    event_registrations.active.exists?(user: user)
  end

  # Search functionality
  def self.search(query)
    return all if query.blank?

    where("title ILIKE ? OR description ILIKE ? OR location ILIKE ? OR category ILIKE ?",
          "%#{query}%", "%#{query}%", "%#{query}%", "%#{query}%")
  end

  private

  def event_date_cannot_be_in_past
    return unless event_date && event_date < Time.current

    errors.add(:event_date, "can't be in the past")
  end
end
