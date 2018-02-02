module ApplicationHelper
  def left_sidebar_link(text, path, icon, options = {})
    content_tag :div, class: "menu-row row" do
      concat(
        content_tag(:div, class: "menu-link-container") do
          concat link_to(text, path, options.merge(class: "sidebar-link"))
        end
      )

      concat(
        content_tag(:div, class: "menu-icon-container") do
          concat fa_icon(icon)
        end
      )
    end
  end
    
  def alert_colors_helper(name, msg)    
    palabra = case name
    when "notice", "info" then "info"
    when "success" then "success"
    when "alert", "warning" then "warning"
    when "error", "danger" then "danger"      
    end

    content_tag :div, msg, class: "alert alert-#{palabra}"
  end
end
