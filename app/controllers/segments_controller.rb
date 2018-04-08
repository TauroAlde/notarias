class SegmentsController < ApplicationController
  before_action :load_segments

  def index
  end

  def show
    @segment = Segment.find(params[:id])
    respond_to do |format|
      format.html { render :index }
      format.js
    end
  end

  def new
    @segment = Segment.new
  end

  def create
    @segment = Segment.new(segment_params)
    @group = @segment.build_group(name: params[:segment][:name])
    @segment.save
    render :index
  end

  private

  def load_segments
    @q = Segment.ransack(params[:q])
    @segments = @q.result(distinct: true)
    if !@segment
      @segments = @segments.where(parent_id: nil)
    end
  end

  def segment_params
    params.require(:segment).permit(:name, :parent_id)
  end
end
