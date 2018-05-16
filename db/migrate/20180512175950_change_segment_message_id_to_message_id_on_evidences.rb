class ChangeSegmentMessageIdToMessageIdOnEvidences < ActiveRecord::Migration[5.0]
  def change
    rename_column :evidences, :segment_message_id, :message_id
  end
end
