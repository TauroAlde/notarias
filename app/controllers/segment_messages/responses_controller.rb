class SegmentMessages::ResponsesController < ApplicationController
  respond_to :json, :html, :js

  def create
    previous_message = Message.find(params[:segment_message_id])
    @segment_message = Message.new(segment_message_params)
    @segment_message.user = current_user
    @segment_message.segment = previous_message.segment

    build_evidence if params[:message] && params[:message][:photo_evidence].present?
    @segment_message.save
    respond_with @segment_message do |format|
      format.json { render json: @segment_message }
      format.html
      format.js { render :create }
    end
  end

  def build_evidence
    @segment_message.evidences.build(
      file: message_evidence_params[:photo_evidence],
      user: current_user
    )
    @segment_message.message = "Imágenes enviadas" if @segment_message.evidences.present? && @segment_message.message.blank?
  end

  def segment_message_params
    params.require(:message).permit(:message)
  end

  def message_evidence_params
    params.require(:message).permit(:photo_evidence)
  end
end
