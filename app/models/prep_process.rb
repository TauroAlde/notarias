class PrepProcess < ApplicationRecord
  belongs_to :segment_processor, foreign_key: :user_id, class_name: 'User'
  belongs_to :processed_segment, foreign_key: :segment_id, class_name: 'Segment'
end
