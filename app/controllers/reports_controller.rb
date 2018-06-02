class ReportsController < ApplicationController
  respond_to :json

  def index
    @reports_loader = ReportsLoader.new(reports_params)
  end

  def segment
    @segments = Segment.ransack(name_cont: params[:q]).result(distinct: true)
    respond_with @segments
  end

  private

  def reports_params
    params.require(:reports_loader).
      permit(
        :include_inner, :from_openning_time, :to_openning_time, :from_closing_time,
        :to_closing_time, :from_votes, :to_votes, base_segments: [])
  end
end
