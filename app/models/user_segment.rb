class UserSegment < ApplicationRecord
  belongs_to :user
  belongs_to :segment
  belongs_to :representatives, ->(o) { where('user_segments.representative = ?', true) }, 
                          class_name: "User", foreign_key: :user_id
end
