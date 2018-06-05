class MessagesKpisController < ApplicationController
  def index
    segments_ids = Segment.segments_for_messages(current_user)
    @messages = Message.find_by_sql(
      <<-SQL
        WITH available_users AS (
          SELECT users.id FROM users
          INNER JOIN user_segments ON user_segments.user_id = users.id
          INNER JOIN user_roles ON user_roles.user_id = users.id
          WHERE user_segments.segment_id IN (#{segments_ids.join(", ")})
          OR user_roles.role_id IN (#{[Role.admin.id, Role.super_admin.id].compact.join(", ")})
        ),
        unread_messages_from_users AS (
          SELECT messages.id FROM messages
          LEFT JOIN available_users ON available_users.id = messages.receiver_id
          WHERE read_at IS NULL
        ),
        unread_messages_from_segments AS (
          SELECT messages.id FROM messages
          LEFT JOIN segments ON segments.id = messages.segment_id
          WHERE messages.read_at IS NULL AND segments.id IN (#{segments_ids.join(", ")})
        )
        SELECT COUNT(result_messages.*) as id FROM (
          SELECT unread_messages_from_users.id FROM unread_messages_from_users
          UNION SELECT unread_messages_from_segments.id FROM unread_messages_from_segments
        ) AS result_messages
      SQL
    )
  end
end
