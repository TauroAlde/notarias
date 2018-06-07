module ReportsHelper
  def percent_difference_color(segment)
    difference = segment.percent_difference
    return "" if difference.is_a?(String)
    difference > 10 ? "text-warning" : ""
  end
end
