class ReportsController < ApplicationController
  respond_to :json
  def index
    if params[:reports]
      @reports_loader = ReportsLoader.new(params[:reports].to_unsafe_h.symbolize_keys)
      @reports_loader.perform
    end
  end

  def segment
    @segments = Segment.ransack(name_cont: params[:q]).result(distinct: true)
    respond_with @segments
  end

  
end
