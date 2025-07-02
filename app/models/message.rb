class Message < ApplicationRecord
  belongs_to :sender, class_name: "User"
  belongs_to :recipient, class_name: "User"

  # Validations
  validates :content, presence: true
  validates :message_type, presence: true, inclusion: { in: %w[direct] }
  validates :recipient, presence: true
  validate :direct_message_validations

  # Scopes
  scope :direct_messages, -> { where(message_type: "direct") }
  scope :between_users, ->(user1, user2) {
    where(
      "(sender_id = ? AND recipient_id = ?) OR (sender_id = ? AND recipient_id = ?)",
      user1.id, user2.id, user2.id, user1.id
    ).where(message_type: "direct")
  }
  scope :ordered, -> { order(:created_at) }

  # Methods
  def direct_message?
    message_type == "direct"
  end

  # Get conversation between two users
  def self.conversation_between(user1, user2)
    between_users(user1, user2)
  end

  # Get latest messages for a user's conversations
  def self.latest_conversations_for(user)
    # Get latest direct messages
    direct_conversations = joins(:recipient, :sender)
      .where("sender_id = ? OR recipient_id = ?", user.id, user.id)
      .where(message_type: "direct")
      .select("DISTINCT ON (LEAST(sender_id, recipient_id), GREATEST(sender_id, recipient_id)) messages.*")
      .order("LEAST(sender_id, recipient_id), GREATEST(sender_id, recipient_id), created_at DESC")

    # Order by latest activity
    Message.from("(#{direct_conversations.to_sql}) as messages")
           .order(created_at: :desc)
  end

  def created_at_date
    created_at.to_date
  end

  private

  def direct_message_validations
    return unless recipient

    # Check if users are matched - find any common event where they're matched
    common_matches = UserMatch.where(
      "(user1_id = ? AND user2_id = ?) OR (user1_id = ? AND user2_id = ?)",
      sender.id, recipient.id, recipient.id, sender.id
    )

    if common_matches.empty?
      errors.add(:recipient, "You can only message matched users")
    end
  end
end
