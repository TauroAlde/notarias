class AddReadAtToSegmentMessage < ActiveRecord::Migration[5.0]
  def change
    add_column :segment_messages, :read_at, :datetime
  end
end
