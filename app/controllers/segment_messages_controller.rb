class SegmentMessagesController < ApplicationController
  before_action :load_segment, except: [:index, :show]
  before_action :load_previous_messages, except: [:index, :show]
  respond_to :json, :html, :js

  def create
    @segment_message = Message.new(segment_message_params)
    @segment_message.user = current_user
    @segment_message.segment = @segment

    build_evidence if params[:segment_message][:photo_evidence].present?
    @segment_message.save
    respond_with @segment_message do |format|
      format.json { render json: @segment_message }
      format.html
      format.js { render :create }
    end
  end

  def index
    @segment_messages = Message.select_distinct_by_raw_query(current_user)
  end

  def show
    segment_message = Message.find(params[:id])
    @segment_messages = Message
      .includes(segment: { messages: [:user, :segment] }, user: { messages: [:user, :segment] })
      .where(segment: segment_message.segment).order(:created_at)
    @segment_messages.update_all(read_at: DateTime.now)
    @segment_messages = @segment_messages.last(20)
  end

  private

  def load_previous_messages
    @previous_messages = current_user.segment_messages.where(segment: @segment)
  end

  def build_evidence
    @segment_message.evidences.build(
      file: message_evidence_params[:photo_evidence],
      user: current_user
    )
  end

  def load_segment
    @segment = Segment.find(params[:segment_id])
  end

  def segment_message_params
    params.require(:message).permit(:message)
  end

  def message_evidence_params
    params.require(:message).permit(:photo_evidence)
  end
end
