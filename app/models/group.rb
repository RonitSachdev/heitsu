class Group < ApplicationRecord
  belongs_to :event
  belongs_to :creator, class_name: 'User'
  
  # Member relationships
  has_many :group_members, dependent: :destroy
  has_many :users, through: :group_members
  
  # Swipe and join relationships
  has_many :group_swipes, dependent: :destroy
  has_many :group_join_requests, dependent: :destroy
  
  # Message relationships
  has_many :messages, dependent: :destroy

  # Validations
  validates :name, presence: true
  validates :description, presence: true
  validates :max_members, presence: true, numericality: { greater_than: 0 }
  validate :creator_must_be_registered_for_event

  # Callbacks
  after_create :add_creator_as_admin

  # Scopes
  scope :with_available_spots, -> { joins(:group_members).group('groups.id').having('COUNT(group_members.id) < groups.max_members') }

  # Methods
  def available_spots
    max_members - group_members.count
  end

  def full?
    available_spots <= 0
  end

  def member_count
    group_members.count
  end

  def has_member?(user)
    group_members.exists?(user: user)
  end

  def admin_users
    group_members.where(role: 'admin').includes(:user).map(&:user)
  end

  def regular_members
    group_members.where(role: 'member').includes(:user).map(&:user)
  end

  def can_join?(user)
    !full? && !has_member?(user) && user.registered_for_event?(event)
  end

  def join_user!(user, role: 'member')
    return false unless can_join?(user)
    
    group_members.create!(user: user, role: role)
  end

  # Get groups user can swipe on for an event
  def self.available_for_swiping(user, event)
    return Group.none unless user.registered_for_event?(event)
    
    # Get groups for the event that user is not a member of
    event_groups = event.groups.where.not(id: user.groups.where(event: event).select(:id))
    
    # Exclude groups already swiped on
    already_swiped_ids = user.group_swipes.joins(:group).where(groups: { event: event }).pluck(:group_id)
    
    event_groups.where.not(id: already_swiped_ids).with_available_spots
  end

  private

  def creator_must_be_registered_for_event
    unless creator&.registered_for_event?(event)
      errors.add(:creator, "must be registered for this event")
    end
  end

  def add_creator_as_admin
    group_members.create!(user: creator, role: 'admin')
  end
end
