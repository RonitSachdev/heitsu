class UserMatch < ApplicationRecord
  belongs_to :user1
  belongs_to :user2
  belongs_to :event
end
