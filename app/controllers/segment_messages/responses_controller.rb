class SegmentMessages::ResponsesController < ApplicationController
  respond_to :json, :html, :js

  def create
    @segment = Segment.find(params[:segment_message_id])
    @message = @segment.messages.build(segment_message_params)
    @message.user = current_user
    @message.read_at = DateTime.now

    build_evidence if params[:message] && params[:message][:photo_evidence].present?
    @message.save
  end

  def build_evidence
    @message.evidences.build(
      file: message_evidence_params[:photo_evidence],
      user: current_user
    )
    @message.message = "Imágenes enviadas" if @message.evidences.present? && @segment_message.message.blank?
  end

  def segment_message_params
    params.require(:message).permit(:message)
  end

  def message_evidence_params
    params.require(:message).permit(:photo_evidence)
  end
end
