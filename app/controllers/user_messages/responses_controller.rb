class UserMessages::ResponsesController < ApplicationController
  respond_to :json, :html, :js

  def create
    previous_message = Message.find(params[:user_message_id])
    @user_message = Message.new(user_message_params)
    @user_message.user = current_user
    @user_message.receiver = previous_message.user

    build_evidence if params[:message] && params[:message][:photo_evidence].present?
    @user_message.save
    respond_with @user_message do |format|
      format.json { render json: @user_message }
      format.html
      format.js { render :create }
    end
  end

  def build_evidence
    @user_message.evidences.build(
      file: message_evidence_params[:photo_evidence],
      user: current_user
    )
    @user_message.message = "Imágenes enviadas" if @user_message.evidences.present? && @user_message.message.blank?
  end

  def user_message_params
    params.require(:message).permit(:message)
  end

  def message_evidence_params
    params.require(:message).permit(:photo_evidence)
  end
end
