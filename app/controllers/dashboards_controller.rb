class DashboardsController < ApplicationController
  before_action :autorize_manage_dashboard

  def index
    @candidacies_loader = PoliticalCandidaciesLoader.new(Segment.root)
    @captured_processes = PrepProcess.completed.last(6)
  end

  private

  def autorize_manage_dashboard
    authorize! :manage, :dashboard
  end
end
