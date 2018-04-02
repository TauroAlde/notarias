module DashboardsHelper
  def login_checkbox_tag(form_block)
    content_tag(:label, class: "custom-control custom-checkbox") do
      concat(check_box_tag("user[remember_me]", form_block.object.remember_me, class: "custom-control-input"))
      concat(content_tag(:span, "", class: "custom-control-indicator"))
      concat(content_tag(:span, t(:remember_me), class: "custom-control-description"))
    end
  end

  def prep_capture_process_route
    if current_user.segments.present?
      new_segment_prep_process_path(current_user.segments.last)
    else
      # Cambiar el numero 1 por el nodo raiz del arbol de segments
      new_segment_prep_process_path(1)
    end
  end
end
