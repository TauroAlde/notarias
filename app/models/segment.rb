class Segment < ApplicationRecord
  belongs_to :parent_segment, foreign_key: :parent_id, class_name: "Segment", optional: true
  has_many :segments, foreign_key: :parent_id, class_name: "Segment", inverse_of: :parent_segment
  # representatives are the entity in charge of the segment in most cases the "casilla"
  # o the leaf segment of the tree
  has_many :representative_users, -> { joins(:user_segments).where('user_segments.representative = ?', true) }, 
                          through: :user_segments, class_name: "User", foreign_key: :user_id
  has_many :non_representative_users, -> { joins(:user_segments).where('user_segments.representative = ? OR user_segments.representative IS NULL', false) }, 
                          through: :user_segments, class_name: "User", foreign_key: :user_id
  has_many :user_segments
  has_many :users, through: :user_segments
  has_many :prep_processes
  has_many :segment_processors, through: :prep_processes, foreign_key: :segment_id, class_name: 'User'

  has_many :political_candidacies
  has_many :candidacies, through: :political_candidacies
  has_many :candidates, through: :political_candidacies
  has_many :messages
  has_many :evidences, through: :messages
  belongs_to :district

  validates :name, uniqueness: true

  has_closure_tree
  
  has_many :self_and_descendants, through: :descendant_hierarchies, source: :descendant
  has_many :self_and_ancestors, through: :ancestor_hierarchies, source: :ancestor

  def self.managed_by_ids(user)
    if user.representative?
      (user.represented_segments.map(&:self_and_descendant_ids).flatten + user.non_represented_segments.pluck(:id)).flatten.uniq
    elsif user.only_common?
      user.segments.pluck(:id)
    else
      Segment.pluck(:id)
    end
  end

  def self.with_messages_for(user)
    includes(
      messages: Message::INCLUDES_BASE,
      user_segments: [:user]).joins(:messages).
    where(id: Segment.managed_by_ids(user))
  end

  def last_message
    messages.order(id: :asc).last
  end

  def last_message_evidences_count
    last_message ? last_message.evidences.count : 0
  end

  def unread_messages_count
    messages.unread.count
  end

  def created_at_day_format
    last_message ? last_message.created_at.strftime("%H:%M %P") : ""
  end
end
