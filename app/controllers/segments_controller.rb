class SegmentsController < ApplicationController
  before_action :load_segment, only: [:show, :jstree_segment]
  #before_action :representative_restrictions, only: [:show]

  def show
    authorize! :show, @segment
    load_candidacies
    @current_branch_ids = load_current_tree(@segment)
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
    @current_segment = preloaded_segment.find(params[:"current-segment-id"])
    @current_branch_ids = load_current_tree(@segment) | load_current_tree(@current_segment)
    render layout: false
  end

  def jstree_search
    @segments = preloaded_segment.ransack(name_cont: params[:str]).result(distinct: true).map(&:self_and_ancestor_ids).flatten.uniq
    render json: @segments
  end

  private

  def load_current_tree(segment)
    segment.self_and_ancestors_ids
  end

  def load_segment
    @segment = params[:id] == "#" ? preloaded_segment.root : preloaded_segment.find(params[:id])
  end

  def load_candidacies
    @political_candidacies_loader = PoliticalCandidaciesLoader.new(@segment)
  end

  def segment_params
    params.require(:segment).permit(:name, :parent_id)
  end

  def preloaded_segment
    Segment.preload(:users,:non_representative_users)
  end

  def connection_to_users
    { user_segments: :user }
  end
end
