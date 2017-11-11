module ApplicationHelper
  def left_sidebar_link(text, path, icon, options = {})
    content_tag :div, class: "menu-row row" do
      concat(
        content_tag(:div, class: "menu-link-container") do
          concat link_to(text, path, class: "sidebar-link")
        end
      )

      concat(
        content_tag(:div, class: "menu-icon-container") do
          concat fa_icon(icon)
        end
      )
    end
  end
end
