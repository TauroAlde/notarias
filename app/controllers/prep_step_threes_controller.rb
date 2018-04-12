class PrepStepThreesController < ApplicationController
  before_action :load_prep_step_three
  before_action :load_segment
  before_action :load_political_candidacies_loader

  def update
    @prep_step_three.update data: params[:data]
  end

  private

  def load_political_candidacies_loader
    @political_candidacies_loader = PoliticalCandidaciesLoader.new(@segment)
  end

  def load_segment
    @segment = @prep_step_three.prep_process.processed_segment
  end

  def load_prep_step_three
    @prep_step_three = Prep::StepThree.find(params[:id])
  end
end
