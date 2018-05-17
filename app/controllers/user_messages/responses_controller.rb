class UserMessages::ResponsesController < ApplicationController
  respond_to :json, :html, :js

  def create
    @user = User.find(params[:user_message_id])
    @message = current_user.messages.build(user_message_params)
    @message.receiver = @user

    build_evidence if params[:message] && params[:message][:photo_evidence].present?
    @message.save
  end

  def build_evidence
    @message.evidences.build(
      file: message_evidence_params[:photo_evidence],
      user: current_user
    )
    @message.message = "Imágenes enviadas" if @message.evidences.present? && @message.message.blank?
  end

  def user_message_params
    params.require(:message).permit(:message)
  end

  def message_evidence_params
    params.require(:message).permit(:photo_evidence)
  end
end
