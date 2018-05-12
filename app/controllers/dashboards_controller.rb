class DashboardsController < ApplicationController
  before_action :autorize_manage_dashboard

  def index
    @candidacies_loader = PoliticalCandidaciesLoader.new(Segment.root)
    @captured_processes = PrepProcess.completed.last(6)
    @last_segment_messages = managed_segments.unread.where('user_id != ?', current_user.id)
                               .select('distinct on (user_id) *').order(:user_id).last(6)
  end

  def managed_segments
    if current_user.representative?
      Message.where(segment: current_user.segments.map(&:self_and_descendant_ids).flatten.uniq)
    else
      Message
    end
  end

  private

  def autorize_manage_dashboard
    authorize! :manage, :dashboard
  end
end
