class UserMessagesController < ApplicationController
  def index
    @user_messages = Message.select_distinct_by_user_raw_query(current_user)
  end

  def show
    user_message = Message.find(params[:id])
    @user_messages = Message.
      includes(:evidences, receiver: { messages: [:user, :receiver] }, user: { messages: [:user, :receiver] }).
      where(user: [user_message.user, current_user], receiver: [user_message.user, current_user]).
      order(id: :desc).limit(20)
    @user_messages.update_all(read_at: DateTime.now)
    @user_messages = @user_messages.reverse
  end

  def new
    @user = User.find(params[:user_id])
    current_user.messages.create(receiver: @user, message: "Hola") if current_user.messages.where(receiver: @user).blank?
    @user_messages = current_user.messages.where(receiver: @user).
        includes(:evidences, receiver: { messages: [:user, :receiver] }, user: { messages: [:user, :receiver] }).
        order(id: :desc).limit(20)
    @user_messages.update_all(read_at: DateTime.now)
    @user_messages = @user_messages.reverse
  end
end
