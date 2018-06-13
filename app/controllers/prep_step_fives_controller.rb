class PrepStepFivesController < ApplicationController
  before_action :load_prep_step_five
  before_action :load_segment
  before_action :load_political_candidacies_loader

  respond_to :json

  def update
    @prep_step_five.update votes_params
    respond_with @prep_step_five
  end

  private

  def load_political_candidacies_loader
    @political_candidacies_loader = PoliticalCandidaciesLoader.new(@segment)
  end

  def load_segment
    @segment = @prep_step_five.prep_process.processed_segment
  end

  def load_prep_step_five
    @prep_step_five = Prep::StepFive.find(params[:id])
  end

  def votes_params
    params.require(:prep_step_five).permit(:file)
  end
end
