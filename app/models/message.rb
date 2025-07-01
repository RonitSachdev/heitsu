class Message < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :recipient, class_name: 'User', optional: true
  belongs_to :group, optional: true

  # Validations
  validates :content, presence: true
  validates :message_type, presence: true, inclusion: { in: %w[direct group] }
  validate :must_have_recipient_or_group
  validate :direct_message_validations, if: :direct_message?
  validate :group_message_validations, if: :group_message?

  # Scopes
  scope :direct_messages, -> { where(message_type: 'direct') }
  scope :group_messages, -> { where(message_type: 'group') }
  scope :between_users, ->(user1, user2) {
    direct_messages.where(
      "(sender_id = ? AND recipient_id = ?) OR (sender_id = ? AND recipient_id = ?)",
      user1.id, user2.id, user2.id, user1.id
    ).order(:created_at)
  }

  # Methods
  def direct_message?
    message_type == 'direct'
  end

  def group_message?
    message_type == 'group'
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
      .where(message_type: 'direct')
      .select("DISTINCT ON (LEAST(sender_id, recipient_id), GREATEST(sender_id, recipient_id)) messages.*")
      .order("LEAST(sender_id, recipient_id), GREATEST(sender_id, recipient_id), created_at DESC")

    # Get latest group messages for user's groups
    group_conversations = joins(:group)
      .joins("JOIN group_members ON group_members.group_id = messages.group_id")
      .where(group_members: { user_id: user.id })
      .where(message_type: 'group')
      .select("DISTINCT ON (group_id) messages.*")
      .order("group_id, created_at DESC")

    # Combine and order by latest activity
    Message.from("(#{direct_conversations.to_sql} UNION #{group_conversations.to_sql}) as messages")
           .order(created_at: :desc)
  end

  private

  def must_have_recipient_or_group
    if recipient.nil? && group.nil?
      errors.add(:base, "Must have either a recipient or a group")
    elsif recipient.present? && group.present?
      errors.add(:base, "Cannot have both recipient and group")
    end
  end

  def direct_message_validations
    return unless recipient

    # Check if users are matched
    unless UserMatch.exists_between?(sender, recipient, sender.events.joins(:user_matches).first)
      # Find a common event where they're matched
      common_matches = UserMatch.joins(:event)
                               .where("(user1_id = ? AND user2_id = ?) OR (user1_id = ? AND user2_id = ?)",
                                     sender.id, recipient.id, recipient.id, sender.id)

      if common_matches.empty?
        errors.add(:recipient, "You can only message matched users")
      end
    end
  end

  def group_message_validations
    return unless group

    unless group.has_member?(sender)
      errors.add(:group, "You must be a member of this group to send messages")
    end
  end
end
