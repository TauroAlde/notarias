class AddReceiverIdToSegmentMessages < ActiveRecord::Migration[5.0]
  def change
    add_column :segment_messages, :receiver_id, :integer
  end
end
