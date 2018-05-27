module PrepProcessesHelper
  def political_candidacy_input(political_candidacy)
    hidden_field_tag "data[#{political_candidacy.id}]", step_four_data[political_candidacy.id.to_s], class: 'w-100', id: "number-field", min: 0, max: 9999
  end

  def step_four_data
    (@prep_step_four || @prep_process_machine.current_step).data
  end
end
