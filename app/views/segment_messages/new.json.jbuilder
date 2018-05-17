json.(@segment, :id, :name)
json.last_message @segment.last_message
json.unread_messages_count @segment.unread_messages_count
json.last_message_evidences_count @segment.last_message_evidences_count
json.created_at_day_format @segment.created_at_day_format
