class RenameSegmentMessageIdToParentMessageId < ActiveRecord::Migration[5.0]
  def change
    rename_column :messages, :segment_message_id, :parent_message_id
  end
end
