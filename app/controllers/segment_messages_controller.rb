class SegmentMessagesController < ApplicationController
  before_action :load_segment
  before_action :load_previous_messages
  respond_to :json, :html, :js

  def create
    @segment_message = SegmentMessage.new(segment_message_params)
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
    params.require(:segment_message).permit(:message)
  end

  def message_evidence_params
    params.require(:segment_message).permit(:photo_evidence)
  end
end
