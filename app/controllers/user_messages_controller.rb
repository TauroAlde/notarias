class UserMessagesController < ApplicationController
  respond_to :json

  def index
    @users = User.joins(:messages, user_segments: [:segment]).
      where(user_segments: { segment_id: Segment.managed_by_ids(current_user) }).
      where('users.id != ?', current_user.id).
      where(
        '((messages.receiver_id != ? AND messages.user_id = ?) OR (messages.receiver_id = ? AND messages.user_id != ?))',
        current_user.id, current_user.id, current_user.id, current_user.id
      ).where('messages.segment_id IS NULL').uniq
  end

  def show
    user_message = Message.find(params[:id])
    @user_messages = Message.
      includes(:evidences, receiver: { messages: [:user, :receiver] }, user: { messages: [:user, :receiver] }).
      where(user: [user_message.user, current_user], receiver: [user_message.user, current_user]).
      order(id: :desc).limit(20)
    @user_messages.update_all(read_at: DateTime.now)
    @user_messages = @user_messages.reverse
    respond_with @user_messages
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
