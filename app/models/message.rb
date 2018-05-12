class Message < ApplicationRecord
  belongs_to :parent_message, optional: true, class_name: "Message"
  belongs_to :user
  belongs_to :segment, optional: true
  belongs_to :receiver, optional: true, class_name: "User"

  has_many :evidences

  scope :unread, -> { where(read_at: nil) }
  scope :read, -> { where("read_at IS NOT NULL") }

  validates :message, presence: true, allow_blank: false

  def mark_as_read
    update(read_at: DateTime.now)
  end

  def unread_messages_from_chat
    user.messages.unread.where(segment: segment)
  end

  def unread_messages_from_chat_count
    unread_messages_from_chat.count
  end

  def self.select_distinct_by_raw_query(current_user)
    segment_ids = if current_user.representative?
      current_user.segments.map(&:self_and_descendant_ids).flatten.uniq
    elsif current_user.only_common?
      current_user.segments.pluck(:id)
    end

    find_by_sql(
      <<-SQL
        WITH ordered_messages as ( SELECT * FROM messages #{segment_delimiter_query(segment_ids)} ORDER BY updated_at)
        SELECT DISTINCT ON (ordered_messages.user_id, ordered_messages.segment_id) * 
        FROM ordered_messages
        WHERE user_id != #{current_user.id}
        ORDER BY user_id, segment_id
      SQL
    )
  end

  def self.segment_delimiter_query(segment_ids)
    return  "" if segment_ids.blank?
    "WHERE messages.segment_id IN (#{segment_ids.join(", ")})"
  end
end
