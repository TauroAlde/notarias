class PrepStepThreesController < ApplicationController
  before_action :load_prep_step_three

  def update
    binding.pry
  end

  private

  def load_prep_step_three
    @step_three = Prep::StepThree.find(params[:id])
  end
end
