class Event < ApplicationRecord
  # User relationships
  has_many :event_registrations, dependent: :destroy
  has_many :users, through: :event_registrations
  
  # Swiping and matching relationships
  has_many :user_swipes, dependent: :destroy
  has_many :user_matches, dependent: :destroy
  
  # Group relationships
  has_many :groups, dependent: :destroy

  # Validations
  validates :title, presence: true
  validates :description, presence: true
  validates :location, presence: true
  validates :event_date, presence: true
  validates :category, presence: true
  validates :max_attendees, presence: true, numericality: { greater_than: 0 }

  # Scopes
  scope :upcoming, -> { where('event_date > ?', Time.current) }
  scope :by_category, ->(category) { where(category: category) }
  scope :by_location, ->(location) { where('location ILIKE ?', "%#{location}%") }

  # Methods
  def spots_remaining
    max_attendees - event_registrations.count
  end

  def full?
    spots_remaining <= 0
  end

  def past?
    event_date < Time.current
  end

  def today?
    event_date.to_date == Date.current
  end

  def registered_users_count
    event_registrations.count
  end

  # Search functionality
  def self.search(query)
    return all if query.blank?
    
    where("title ILIKE ? OR description ILIKE ? OR location ILIKE ? OR category ILIKE ?", 
          "%#{query}%", "%#{query}%", "%#{query}%", "%#{query}%")
  end
end
