json.(@message, :id, :message, :updated_at, :user_id, :receiver_id, :segment_id)
json.created_at @message.created_at_day_format
json.read_at @message.read_at_day_format
json.evidences @message.evidences do |evidence|
  json.(evidence, :id, :updated_at, :message_id, :user_id)
  json.url evidence.file.url
  json.name evidence.file.file.original_filename
end
json.user do
  json.(@message.user, :id, :full_name, :name, :mother_last_name, :father_last_name)
end
json.receiver do
  json.(@message.receiver, :id, :full_name, :name, :mother_last_name, :father_last_name)
end
