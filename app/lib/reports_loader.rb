class ReportsLoader
  attr_reader :segment, :include_inner, :from_openning_time, :to_openning_time, :from_closing_time, :to_closing_time, :segments

  def initialize(segment:, include_inner:, from_openning_time: nil, to_openning_time: nil, from_closing_time: nil, to_closing_time: nil)
    @segment = Segment.find(segment)
    @include_inner = include_inner
    date = DateTime.now
    # fix date format
    @from_openning_time = Time.new(date.year, date.month, date.day, from_openning_time) if !from_openning_time.blank?
    @to_openning_time   = Time.new(date.year, date.month, date.day, to_openning_time)   if !to_openning_time.blank?
    @from_closing_time  = Time.new(date.year, date.month, date.day, from_closing_time)  if !from_closing_time.blank?
    @to_closing_time    = Time.new(date.year, date.month, date.day, to_closing_time)    if !to_closing_time.blank?
  end

  def perform
    get_segments
  end

  def get_segments
    return @segments if !@segments.blank?
    @segments = filter_by_dates
  end

  def discrepant_greater_than_segments
    @discrepant_segments = get_segments.
      joins(prep_processes: :prep_step_threes).
      where("prep_step_threes.voters_count > segments.nominal_count")
  end

  def discrepant_less_than_segments
    @discrepant_segments = get_segments.
      joins(prep_processes: :prep_step_threes).
      where("prep_step_threes.voters_count < segments.nominal_count")
  end

  def filter_by_dates
    return segment.self_and_descendants if !filtering_by_time?
    @segments = segment.self_and_descendants
    @segments = @segments.joins(
      <<-SQL
        INNER JOIN prep_processes ON prep_processes.segment_id = segments.id
        LEFT JOIN prep_step_ones ON prep_step_ones.prep_process_id = prep_processes.id
      SQL
    ).where(
      <<-SQL
         #{ openning_query }
         #{ closing_query }
      SQL
    )
  end

  def openning_query
    (from_openning_time.blank? ? "" : " AND prep_processes.created_at >= #{from_openning_time} ") +
    (to_openning_time.blank? ? "" : " AND prep_processes.created_at <= #{to_openning_time} ")
  end

  def closing_query
    (from_openning_time.blank? ? "" : " AND prep_processes.created_at >= #{from_closing_time} ") +
    (to_openning_time.blank? ? "" : " AND prep_processes.created_at <= #{to_closing_time} ")
  end

  def filtering_by_time?
    !from_openning_time.blank? || !to_openning_time.blank? || !from_openning_time.blank? || !to_openning_time.blank?
  end
end