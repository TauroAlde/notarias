class SegmentMessagesController < ApplicationController
  def index
    @segment_messages = Message.select_distinct_by_segment_raw_query(current_user)
  end

  def show
    segment_message = Message.find(params[:id])

    @segment_messages = Message
      .includes(:evidences, segment: { messages: [:user, :segment] }, user: { messages: [:user, :segment] })
      .where(segment: segment_message.segment).order(id: :desc).limit(20)
    @segment_messages.update_all(read_at: DateTime.now)
    @segment_messages = @segment_messages.reverse
  end
end
