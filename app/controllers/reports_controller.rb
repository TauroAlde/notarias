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
    if params[:reports_loader].blank?
      {}
    else
      params.require(:reports_loader).
        permit(
          :include_inner, :from_openning_time, :to_openning_time, :from_closing_time,
          :to_closing_time, :votes_percent, :greater_than, base_segments: [])
    end
  end
end
