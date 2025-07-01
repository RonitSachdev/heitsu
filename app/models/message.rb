class Message < ApplicationRecord
  belongs_to :sender
  belongs_to :recipient
  belongs_to :group
end
