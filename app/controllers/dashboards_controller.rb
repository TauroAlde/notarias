class DashboardsController < ApplicationController
  before_action :autorize_manage_dashboard

  def index
    @candidacies_loader = PoliticalCandidaciesLoader.new(Segment.root)
    @captured_processes = PrepProcess.completed.last(6)
    @segments_with_messages = Segment.with_messages_for(current_user).uniq.last(3)
    @users_with_messages = User.user_chats(current_user).uniq.last(3)
  end

  private

  def autorize_manage_dashboard
    authorize! :manage, :dashboard
  end
end
