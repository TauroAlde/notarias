class UserSegment < ApplicationRecord
  belongs_to :user
  belongs_to :segment
  belongs_to :representative_user, class_name: "User", foreign_key: :user_id
end
