module SegmentsHelper
  def jstree_segment_class(segment)
    if is_segment_open?(segment)
      'jstree-open'
    elsif !segment.leaf?
      'jstree-closed'
    end
  end

  def segment_link_class(segment)
    base_class = []
    base_class << "jstree-disabled" if is_segment_disabled?(segment) 
    base_class << "jstree-clicked" if segment == @current_segment
    base_class.join(" ")
  end

  def is_segment_open?(segment)
    current_branch?(segment)
  end

  def current_branch?(segment)
    @current_branch_ids.include?(segment.id)
  end

  def is_segment_disabled?(segment)
    if available_segments_ids.include?(:all) || available_segments_ids.include?(segment.id)
      false
    else
      true
    end
  end

  def available_segments_ids
    return @available_segments_ids if @available_segments_ids
    @available_segments_ids = if current_user.admin? || current_user.super_admin?
      [:all]
    else
      current_user.represented_segments.map(&:self_and_descendant_ids).flatten.uniq
    end
  end

  def global_presidential_bar_chart
    loader = PoliticalCandidaciesLoader.new(Segment.root)
    candidacy = Candidacy.find_by(name: Candidacy::PRESIDENCIA)
    bar_chart(
      loader.political_candidacy_data(candidacy),
      default_options.merge({ legend: false })
    )
  end

  def segment_bar_chart(candidacy, options = {})
    bar_chart(candidacies_loader.political_candidacy_data(candidacy), default_options.merge(options))
  end

  def segment_pie_chart(candidacy, options = {})
    pie_chart(candidacies_loader.political_candidacy_data(candidacy), default_options.merge(options))
  end

  def segment_line_chart(candidacy, options = {})
    line_chart(candidacies_loader.political_candidacy_data_by_time(candidacy), default_options.merge(options))
  end

  def segment_district_bar_chart(candidacy, options = {})
    bar_chart(candidacies_loader.political_candidacy_district_data(candidacy), default_options.merge(options))
  end

  private

  def candidacies_loader
    return @candidacies_loader if @candidacies_loader
    @candidacies_loader = PoliticalCandidaciesLoader.new(@segment)
  end

  def default_options
    {
      legend: false,
      maintainAspectRatio: false,
      height: "200",
      scales: {
        yAxes: [{
          ticks: {
            beginAtZero: true
          }
        }],
        xAxes: [{
          ticks: {
            autoSkip: false,
            beginAtZero: true
          }
        }]
      }
    }
    #{
    #  scales: {
    #    yAxes: [{
    #      ticks: {
    #        callback: js_inline("function(value, index, values) { return '<div>dick</div>' }")
    #      }
    #    }]
    #  }
    #}
  end
end
