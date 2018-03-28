class PrepProcessesController < ApplicationController
  def new
    @prep_process = PrepProcess.
      find_or_create_by(
        processed_segment: params[:segment_id], segment_processor: params[:user_id] || current_user)
  end
end
