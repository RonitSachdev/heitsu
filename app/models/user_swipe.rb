class UserSwipe < ApplicationRecord
  belongs_to :swiper
  belongs_to :swiped_user
  belongs_to :event
end
