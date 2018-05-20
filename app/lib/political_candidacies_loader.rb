class PoliticalCandidaciesLoader
  attr_accessor :segment, :political_candidacies, :candidacies, :data_hash
  COLORS=["#1e5839", "#292828", "#d87e7e", "#628b9f", "#19455a", "#a5c392"]

  def initialize(segment)
    @segment = segment
    load_candidacies
    load_political_candidacies_from_candidacies_and_segment_upstream
  end

  def filter_by_political_party(political_party)
    political_candidacies.joins(candidate: :political_party).where("political_parties.id = ?", political_party).uniq
  end

  def filter_by_candidacy(candidacies)
    return political_candidacies unless candidacies
    political_candidacies.where(candidacy: candidacies).uniq
  end

  def political_candidacy_data(candidacy = nil)
    @data_hash = ActiveRecord::Base.connection.execute(
      <<-SQL
        SELECT #{candidacies_fields_queries(filter_by_candidacy(candidacy))} 
        FROM prep_step_fours
        INNER JOIN prep_processes ON prep_processes.id = prep_step_fours.prep_process_id
        INNER JOIN segments ON segments.id = prep_processes.segment_id
        WHERE segments.id IN (#{segment.self_and_descendant_ids.join(", ")})
      SQL
    ).to_a[0]
    print_out_candidacy_data(candidacy)
  end

  def political_candidacy_district_data(candidacy = nil)
    @data_hash = ActiveRecord::Base.connection.execute(
      <<-SQL
        SELECT #{candidacies_fields_queries(filter_by_candidacy(candidacy))} 
        FROM prep_step_fours
        INNER JOIN prep_processes ON prep_processes.id = prep_step_fours.prep_process_id
        INNER JOIN segments ON segments.id = prep_processes.segment_id
        INNER JOIN districts ON districts.id = segments.district_id 
        WHERE districts.id = #{segment.district_id}
      SQL
    ).to_a[0]
    print_out_candidacy_data(candidacy)
  end

  def print_out_candidacy_data(candidacy)
    {
      labels: @data_hash ? @data_hash.keys : [],
      datasets: [{
        label: "Votos",
        data: @data_hash ? @data_hash.values : [],
        backgroundColor: data_colors,
        borderColor: data_colors
      }]
    }
  end

  def political_candidacy_data_by_time(candidacy = nil)
    dates = (DateTime.now.beginning_of_day.to_i..DateTime.now.end_of_day.to_i).
      to_a.in_groups_of(2.hours).collect(&:first).collect { |t| Time.at(t).strftime("%Y-%m-%d %H:%M:%S") }
    {
      labels: dates.map { |date| date },
      datasets: dataset_by_date(candidacy, dates)
    }
  end

  def data_colors
    COLORS[0..(@data_hash ? @data_hash.length : 1)]
  end

  private

  def dataset_by_date(candidacy, dates)
    political_candidacies_list = filter_by_candidacy(candidacy)
    political_candidacies_list.map do |political_candidacy|
      @data_hash = ActiveRecord::Base.connection.execute(
        "SELECT #{candidacies_fields_queries_by_date(political_candidacy, dates)}"
      ).to_a[0]

      {
        label: political_candidacy.candidate.name,
        data: @data_hash.values
      }
    end
  end

  def candidacies_fields_queries_by_date(political_candidacy, dates_list)
    dates_list.map do |date|
      <<-SQL
        (
          SELECT COALESCE(sum((prep_step_fours.data ->> '#{political_candidacy.id}')::int), 0) AS \"#{date}\"
          FROM prep_step_fours
          WHERE prep_step_fours.created_at > '#{date.to_datetime - 2.hours}'
          AND prep_step_fours.created_at < '#{date.to_datetime + 2.hours}'
        ) AS \"#{date}\"
      SQL
    end.join(", ")
  end

  def candidacies_fields_queries(political_candidacies = nil)
    (political_candidacies || @political_candidacies).map do |political_candidacy|
      "sum((prep_step_fours.data ->> '#{political_candidacy.id}')::int) as \"#{political_candidacy.candidate.name.downcase}\""
    end.join(", ")
  end

  def load_full_branch
    PoliticalCandidacy.where(
      segment_id: (segment.self_and_ancestors_ids + segment.self_and_descendant_ids).uniq
    )
  end

  def load_candidacies
    @candidacies = Candidacy
                     .joins(:political_candidacies)
                     .where(political_candidacies: { id: load_full_branch.pluck(:id) }).uniq
    @candidacies = @candidacies.where("political_candidacies.district_id = ? OR political_candidacies.district_id IS NULL", segment.district.id) if segment.district
    @candidacies
  end

  def load_political_candidacies_from_candidacies_and_segment_upstream
    @political_candidacies = PoliticalCandidacy.where(candidacy: candidacies, segment_id: segment.self_and_ancestors_ids)
    @political_candidacies = @political_candidacies.where("district_id = ? OR district_id IS NULL", segment.district.id) if segment.district
    @political_candidacies
  end
end