if @message.errors.empty?
  json.(@message, :id, :message, :updated_at, :user_id, :receiver_id, :segment_id)
  json.created_at @message.created_at_day_format
  json.read_at @message.read_at_day_format
  json.evidences @message.evidences do |evidence|
    json.(evidence, :id, :updated_at, :message_id, :user_id)
    json.url evidence.file.url
    json.name evidence.file.file.filename
  end
  json.user do
    json.(@message.user, :id, :full_name, :name, :mother_last_name, :father_last_name)
  end
  json.segment do
    json.(@message.segment, :id, :name)
  end
else
  json.errors do
    json.array! @message.errors.full_messages
  end
end
