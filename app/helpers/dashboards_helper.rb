module DashboardsHelper
  def login_checkbox_tag(form_block)
    content_tag(:label, class: "custom-control custom-checkbox") do
      concat(form_block.check_box :remember_me, class: "custom-control-input")
      concat(content_tag(:span, "", class: "custom-control-indicator"))
      concat(content_tag(:span, t(:remember_me), class: "custom-control-description"))
    end
  end
end
