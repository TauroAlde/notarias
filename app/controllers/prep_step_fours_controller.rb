
class PrepStepFoursController < ApplicationController
  before_action :load_prep_step_four
  before_action :load_segment
  before_action :load_political_candidacies_loader

  def update
    @prep_step_four.update votes_params
  end

  private

  def load_political_candidacies_loader
    @political_candidacies_loader = PoliticalCandidaciesLoader.new(@segment)
  end

  def load_segment
    @segment = @prep_step_four.prep_process.processed_segment
  end

  def load_prep_step_four
    @prep_step_four = Prep::StepFour.find(params[:id])
  end

  def votes_params
    params.require(:prep_step_four).permit(votes_attributes: [:id, :political_party_id, :political_candidacy_id, :votes_count])
  end
end
