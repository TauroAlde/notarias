class ChangeSegmentMessagesToMessages < ActiveRecord::Migration[5.0]
  def change
    rename_table :segment_messages ,:messages
  end
end
