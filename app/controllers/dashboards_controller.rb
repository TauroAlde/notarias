class DashboardsController < ApplicationController
  before_action :autorize_manage_dashboard

  def index
    @candidacies_loader = PoliticalCandidaciesLoader.new(Segment.root)
  end

  private

  def autorize_manage_dashboard
    authorize! :manage, :dashboard
  end
end
