class SegmentMessagesController < ApplicationController
  respond_to :json

  def index
    @segments = Segment.joins(:messages).where(id: Segment.managed_by_ids(current_user)).uniq
    respond_with @segments.as_json(methods: [:last_message, :unread_messages_count, :last_message_evidences_count, :created_at_day_format])
  end

  def show
    @segment = Segment.find(params[:id])
    @messages = @segment.messages.
      includes(:user, :receiver, :segment, :evidences).
      order(id: :desc).limit(20)
    @messages.update_all(read_at: DateTime.now)
    @messages = @messages.reverse
  end

  def new
    @segment = Segment.find(params[:segment_id])
    @segment.messages.create(user: current_user, message: "Hola") if @segment.messages.blank?

    @segment_messages = @segment.messages.includes(
      :evidences, receiver: { messages: [:user, :receiver] }, user: { messages: [:user, :receiver] }
    ).order(id: :desc).limit(20)
  end
end
