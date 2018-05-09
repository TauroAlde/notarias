class SegmentMessage < ApplicationRecord
  belongs_to :segment_message, optional: true
  belongs_to :user
  belongs_to :segment

  has_many :evidences

  scope :unread, -> { where(read_at: nil) }
  scope :read, -> { where("read_at IS NOT NULL") }

  validates :message, presence: true, allow_blank: false

  def mark_as_read
    update(read_at: DateTime.now)
  end
end
