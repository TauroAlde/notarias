class SegmentsController < ApplicationController
  before_action :load_segment, only: [:show, :jstree_segment]
  #before_action :representative_restrictions, only: [:show]

  def show
    authorize! :show, @segment
    load_candidacies
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

  def jstree_segment
    @current_segment = Segment.find(params[:"current-segment-id"])
    render layout: false
  end

  private

  def load_segment
    @segment = params[:id] == "#" ? Segment.root : Segment.find(params[:id])
  end

  def load_candidacies
    @political_candidacies_loader = PoliticalCandidaciesLoader.new(@segment)
  end

  def segment_params
    params.require(:segment).permit(:name, :parent_id)
  end

  def representative_restrictions
    
  end
end
