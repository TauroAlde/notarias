class ReportsLoader
  include ActiveModel::Model

  attr_accessor :base_segments, :include_inner, :from_openning_time,
                :to_openning_time, :from_closing_time, :to_closing_time, :segments,
                :votes_percent, :greater_than

  def initialize(attributes = {})
    super(attributes)
    if base_segments.blank?
      @base_segments = []
      return self
    end
    @base_segments = Segment.where(id: base_segments.select { |s| !s.blank? })
    @segments = segments_or_include_descendants
    @from_openning_time = from_openning_time.to_datetime  if !from_openning_time.blank?
    @to_openning_time   = to_openning_time.to_datetime    if !to_openning_time.blank?
    @from_closing_time  = from_closing_time.to_datetime   if !from_closing_time.blank?
    @to_closing_time    = to_closing_time.to_datetime     if !to_closing_time.blank?
    @votes_percent       = Integer(votes_percent)          if !votes_percent.blank?
    filter
  end

  def discrepant_voters_greater
    @discrepant_segments = get_segments.
      joins(prep_processes: :prep_step_threes).
      where("prep_step_threes.voters_count >= segments.nominal_count")
  end

  def discrepant_voters_lesser
    @discrepant_segments = get_segments.
      joins(prep_processes: :prep_step_threes).
      where("prep_step_threes.voters_count =< segments.nominal_count")
  end

  def filter
    filter_by_dates
    filter_by_votes
    @segments
  end

  def filter_by_dates
    return @segments if !filtering_by_time?
    @segments = @segments.where(chain_time_queries)
  end

  def filter_by_votes
    return @segments if !filtering_by_votes?
    @segments = @segments.where(voters_query)
  end

  def base_segments_for_select
    base_segments.map { |s| [s.name, s.id] }
  end

  def filtering_by_votes?
    votes_percent.present?
  end

  def filtering_by_time?
    filtering_by_openning? || filtering_by_closing?
  end

  def filtering_by_openning?
    from_openning_time.present? || to_openning_time.present?
  end

  def filtering_by_closing?
    from_openning_time.present? || to_openning_time.present?
  end

  private
  
  def voters_query
    base_sql = []
    if greater_than?
      " (((prep_step_threes.voters_count - segments.nominal_count) * 100) / segments.nominal_count) >= #{votes_percent} "
    else
      " (((segments.nominal_count - prep_step_threes.voters_count) * 100) / segments.nominal_count) >= #{votes_percent} "
    end
  end

  def chain_time_queries
    base_sql = []
    base_sql << from_openning_query if !from_openning_time.blank?
    base_sql << to_openning_query   if !to_openning_time.blank?
    base_sql << from_closing_query  if !from_closing_time.blank?
    base_sql << to_closing_query    if !to_closing_time.blank?
    base_sql.join(" AND ")
  end

  def from_openning_query
    "prep_processes.created_at >= '#{from_openning_time}'"
  end

  def to_openning_query
    "prep_processes.created_at <= '#{to_openning_time}'"
  end

  def from_closing_query
    "prep_processes.created_at >= '#{from_closing_time}'"
  end

  def to_closing_query
    "prep_processes.created_at <= '#{to_closing_time}'"
  end

  def segments_or_include_descendants
    return @segments if @segments.present?

    if base_segments.empty?
      @segments = base_segments
      return @segments
    end
    @segments = (include_inner? ? return_with_ancestor(base_segments) : base_segments).joins(
      <<-SQL
        LEFT JOIN prep_processes ON prep_processes.segment_id = segments.id
        LEFT JOIN prep_step_ones ON prep_step_ones.prep_process_id = prep_processes.id
        LEFT JOIN prep_step_threes ON prep_step_threes.prep_process_id = prep_processes.id
      SQL
    ).uniq
  end

  def include_inner?
    include_inner == "1"
  end

  def greater_than?
    greater_than == "1"
  end

  def return_with_ancestor(base_segments)
    base_segments_ids = base_segments.pluck(:id)
    with_ancestor_list = Segment.with_ancestor(base_segments_ids).pluck(:id)
    with_ancestor_list.blank? ? base_segments : Segment.where(id: with_ancestor_list + base_segments_ids).uniq
  end
end