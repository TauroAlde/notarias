class UserMessagesController < ApplicationController
  respond_to :json

  def index
    @users = User.includes(received_messages: Message::INCLUDES_BASE, user_segments: [:segment]).user_chats(current_user)
  end

  def show
    @user = User.includes(messages: Message::INCLUDES_BASE, user_segments: [:segment]).find(params[:id])
    @messages = @user.messages_between_self_and(current_user).limit(20)
    @messages.update_all(read_at: DateTime.now)
    @messages = @messages.reverse
  end

  def new
    @user = User.includes(messages: Message::INCLUDES_BASE, user_segments: [:segment]).find(params[:user_id])
  end
end
