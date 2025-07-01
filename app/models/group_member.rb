class GroupMember < ApplicationRecord
  belongs_to :user
  belongs_to :group

  # Validations
  validates :role, presence: true, inclusion: { in: %w[admin member] }
  validates :user_id, uniqueness: { scope: :group_id }
  validate :user_registered_for_event

  # Scopes
  scope :admins, -> { where(role: 'admin') }
  scope :members, -> { where(role: 'member') }

  # Methods
  def admin?
    role == 'admin'
  end

  def member?
    role == 'member'
  end

  def promote_to_admin!
    update!(role: 'admin')
  end

  def demote_to_member!
    update!(role: 'member')
  end

  private

  def user_registered_for_event
    unless user&.registered_for_event?(group&.event)
      errors.add(:user, "must be registered for the event")
    end
  end
end
