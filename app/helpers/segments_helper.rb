module SegmentsHelper
  def segment_bar_chart(candidacy)
    candidacies_loader = PoliticalCandidaciesLoader.new(@segment)
    bar_chart(candidacies_loader.political_candidacies_data(candidacy), default_options)
  end

  def default_options
    {
      height: "200"
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
