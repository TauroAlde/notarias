class DashboardsController < ApplicationController

  def index
    @candidacies_loader = PoliticalCandidaciesLoader.new(Segment.root)
  end

end
