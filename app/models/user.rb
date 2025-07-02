class User < ApplicationRecord
  has_secure_password

  # Predefined interests users can select from
  AVAILABLE_INTERESTS = [
    "🎵 Music", "🏃‍♂️ Running", "📚 Reading", "☕ Coffee", "🎭 Theater", "✈️ Travel",
    "💻 Technology", "🍕 Food", "🎮 Gaming", "🏀 Basketball", "🚀 Startups", "⚽ Soccer",
    "🎨 Art", "📸 Photography", "🍷 Wine", "🎭 Museums", "📖 Books", "🎬 Movies",
    "🏋️‍♂️ Fitness", "🏈 Football", "🌮 Mexican Food", "🍺 Beer", "🎪 Comedy", "🎯 Darts",
    "💃 Dancing", "🏖️ Beach", "🎭 Shows", "🌮 Food Trucks", "🎸 Guitar", "🥾 Hiking",
    "🧗‍♂️ Rock Climbing", "🏕️ Camping", "🚴‍♂️ Biking", "🍺 Craft Beer", "🎵 Music Festivals",
    "🌿 Nature", "🐕 Dogs", "🐱 Cats", "✍️ Writing", "🚶‍♀️ Walking", "👩‍🍳 Cooking",
    "🎲 Board Games", "🧘‍♀️ Yoga", "🏊‍♀️ Swimming", "⛷️ Skiing", "🏄‍♀️ Surfing", "🎾 Tennis",
    "🏌️‍♂️ Golf", "🎳 Bowling", "🎺 Jazz", "🎤 Karaoke", "🍜 Ramen", "🍣 Sushi",
    "🌱 Gardening", "🎨 Painting", "🎭 Acting", "📺 TV Shows", "🎪 Circus", "🎰 Casinos",
    "🏛️ History", "🔬 Science", "🌟 Astrology", "🧠 Psychology", "💼 Business", "📈 Finance"
  ].freeze

  # Event relationships
  has_many :event_registrations, dependent: :destroy
  has_many :events, through: :event_registrations

  # User swiping relationships
  has_many :user_swipes, foreign_key: "swiper_id", dependent: :destroy
  has_many :swiped_users, through: :user_swipes, source: :swiped_user
  has_many :received_swipes, class_name: "UserSwipe", foreign_key: "swiped_user_id", dependent: :destroy
  has_many :swipers, through: :received_swipes, source: :swiper

  # Match relationships
  has_many :matches_as_user1, class_name: "UserMatch", foreign_key: "user1_id", dependent: :destroy
  has_many :matches_as_user2, class_name: "UserMatch", foreign_key: "user2_id", dependent: :destroy

  # Message relationships
  has_many :sent_messages, class_name: "Message", foreign_key: "sender_id", dependent: :destroy
  has_many :received_messages, class_name: "Message", foreign_key: "recipient_id", dependent: :destroy

  # Validations
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :first_name, presence: true
  validates :last_name, presence: true
  validate :interests_must_be_from_available_list

  # Normalize email to lowercase
  before_validation :normalize_email

  # Methods to get all matches
  def matches
    UserMatch.where("user1_id = ? OR user2_id = ?", id, id)
  end

  # Get matched users
  def matched_users
    match_ids = matches.pluck(:user1_id, :user2_id).flatten.uniq - [ id ]
    User.where(id: match_ids)
  end

  # Check if user is registered for an event
  def registered_for_event?(event)
    event_registrations.active.exists?(event: event)
  end

  # Get users to swipe on for a specific event
  def users_to_swipe_for_event(event)
    # Get all users registered for this event
    registered_users = event.users.where.not(id: self.id)

    # Exclude users already swiped on
    swiped_user_ids = user_swipes.where(event: event).pluck(:swiped_user_id)

    registered_users.where.not(id: swiped_user_ids)
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  # Add missing scopes and methods for profile templates
  class << self
    def recent
      order(created_at: :desc)
    end
  end

  # Get recent events for profile
  def recent_events
    events.joins(:event_registrations)
          .where(event_registrations: { user: self })
          .order("event_registrations.created_at DESC")
  end

  # Get recent matches for profile
  def recent_matches
    matches.order(created_at: :desc)
  end

  # New profile methods for Bumble/Tinder interface
  def age
    return nil unless date_of_birth
    ((Date.current - date_of_birth) / 365.25).floor
  end

  def interests_array
    return [] unless interests.present?
    parsed_interests = JSON.parse(interests) rescue []
    # Ensure all interests are from the available list
    parsed_interests.select { |interest| AVAILABLE_INTERESTS.include?(interest) }
  end

  def interests_array=(new_interests)
    # Filter to only include valid interests
    valid_interests = new_interests.select { |interest| AVAILABLE_INTERESTS.include?(interest) }
    self.interests = valid_interests.to_json
  end

  def add_interest(interest)
    return false unless AVAILABLE_INTERESTS.include?(interest)
    current_interests = interests_array
    return true if current_interests.include?(interest)

    current_interests << interest
    self.interests_array = current_interests
    true
  end

  def remove_interest(interest)
    current_interests = interests_array
    current_interests.delete(interest)
    self.interests_array = current_interests
    true
  end

  def has_interest?(interest)
    interests_array.include?(interest)
  end

  def photos_array
    return [] unless photos.present?
    JSON.parse(photos) rescue []
  end

  def location_display
    return city if city.present?
    "Location not set"
  end

  def height_display
    return height if height.present?
    "Height not set"
  end

  def occupation_display
    return occupation if occupation.present?
    "Occupation not set"
  end

  def education_display
    return education if education.present?
    "Education not set"
  end

  def main_photo
    photos_array.first || "default_avatar.jpg"
  end

  def has_complete_profile?
    [
      first_name, last_name, bio, date_of_birth,
      city, interests, occupation, education, height
    ].all?(&:present?)
  end

  def profile_completion_percentage
    fields = [
      first_name, last_name, bio, date_of_birth,
      city, interests, occupation, education, height, photos
    ]
    completed_fields = fields.count(&:present?)
    (completed_fields.to_f / fields.length * 100).round
  end

  # Get interests grouped by category for easier selection
  def self.interests_by_category
    {
      "Entertainment" => [ "🎵 Music", "🎬 Movies", "📚 Reading", "🎮 Gaming", "🎭 Theater", "🎪 Comedy", "🎤 Karaoke", "📺 TV Shows" ],
      "Sports & Fitness" => [ "🏃‍♂️ Running", "🏋️‍♂️ Fitness", "🏀 Basketball", "⚽ Soccer", "🏈 Football", "🎾 Tennis", "🏌️‍♂️ Golf", "🏊‍♀️ Swimming", "🧘‍♀️ Yoga" ],
      "Outdoor Activities" => [ "🥾 Hiking", "🧗‍♂️ Rock Climbing", "🏕️ Camping", "🚴‍♂️ Biking", "🏖️ Beach", "🌿 Nature", "⛷️ Skiing", "🏄‍♀️ Surfing" ],
      "Food & Drink" => [ "🍕 Food", "👩‍🍳 Cooking", "🍷 Wine", "☕ Coffee", "🍺 Beer", "🍜 Ramen", "🍣 Sushi", "🌮 Mexican Food", "🍺 Craft Beer" ],
      "Arts & Culture" => [ "🎨 Art", "📸 Photography", "🎭 Museums", "🎸 Guitar", "🎺 Jazz", "🎨 Painting", "🎭 Acting", "✍️ Writing" ],
      "Technology & Business" => [ "💻 Technology", "🚀 Startups", "💼 Business", "📈 Finance", "🔬 Science" ],
      "Animals & Nature" => [ "🐕 Dogs", "🐱 Cats", "🌱 Gardening", "🌿 Nature" ],
      "Lifestyle" => [ "✈️ Travel", "🚶‍♀️ Walking", "🎲 Board Games", "🌟 Astrology", "🧠 Psychology", "🏛️ History" ]
    }
  end

  private

  def normalize_email
    self.email = email.downcase if email.present?
  end

  def interests_must_be_from_available_list
    return unless interests.present?

    begin
      parsed_interests = JSON.parse(interests)
      invalid_interests = parsed_interests - AVAILABLE_INTERESTS

      if invalid_interests.any?
        errors.add(:interests, "contains invalid interests: #{invalid_interests.join(', ')}")
      end
    rescue JSON::ParserError
      errors.add(:interests, "must be valid JSON")
    end
  end
end
