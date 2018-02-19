module ApplicationHelper
  def left_sidebar_link(text, path, icon, options = {})
    link_to path, class: "menu-row flex-row d-flex #{options[:wrapper_options][:class] if options[:wrapper_options]}" do
      concat fa_icon(icon)
      concat content_tag(:span, text)
    end
  end
    
  def alert_colors_helper(name, msg)    
    notice_class = case name
    when "notice", "info" then "info"
    when "success" then "success"
    when "alert", "warning" then "warning"
    when "error", "danger" then "danger"      
    end

    content_tag :div, msg, class: "alert alert-#{notice_class}"
  end
end
