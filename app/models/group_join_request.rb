class GroupJoinRequest < ApplicationRecord
  belongs_to :user
  belongs_to :group

  # Validations
  validates :status, presence: true, inclusion: { in: %w[pending approved rejected] }
  validates :user_id, uniqueness: { scope: :group_id }
  validate :user_must_be_registered_for_event
  validate :user_not_already_member

  # Scopes
  scope :pending, -> { where(status: 'pending') }
  scope :approved, -> { where(status: 'approved') }
  scope :rejected, -> { where(status: 'rejected') }

  # Methods
  def approve!
    return false unless pending? && group.can_join?(user)
    
    ActiveRecord::Base.transaction do
      update!(status: 'approved')
      group.join_user!(user)
    end
  end

  def reject!
    update!(status: 'rejected')
  end

  def pending?
    status == 'pending'
  end

  def approved?
    status == 'approved'
  end

  def rejected?
    status == 'rejected'
  end

  private

  def user_must_be_registered_for_event
    unless user.registered_for_event?(group.event)
      errors.add(:user, "must be registered for this event")
    end
  end

  def user_not_already_member
    if group.has_member?(user)
      errors.add(:user, "is already a member of this group")
    end
  end
end
