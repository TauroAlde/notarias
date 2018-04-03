class PrepProcessesController < ApplicationController
  before_action :load_user
  before_action :load_segment

  def new
    @prep_process_machine = PrepProcessMachine.new(segment: @segment, user: @user)
    @prep_process_machine.find_or_create
  end

  private

  def load_user
    @user = params[:user_id] ? User.find(params[:user_id]) : current_user
  end

  def load_segment
    @segment = Segment.find(params[:segment_id])
  end
end
