if @prep_step_five.errors.empty?
  json.(@prep_step_five, :id, :created_at, :updated_at)
  json.url @prep_step_five.file.url
  json.name @prep_step_five.file.file.filename
else
  json.errors do
    json.array! @prep_step_five.errors.full_messages
  end
end
