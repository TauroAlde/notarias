class PrepProcessMachine
  include ActiveModel::Model

  attr_accessor :segment, :user, :prep_process, :current_step

  def find_or_create
    @prep_process = PrepProcess.
      find_or_create_by!(processed_segment: segment, segment_processor: user)
    create_prep_process_step_object
    @prep_process
  rescue ActiveRecord::RecordInvalid => e
    errors.add(:base, e.message)
  end

  def create
    @prep_process = PrepProcess.create!(processed_segment: segment, segment_processor: user)
  rescue ActiveRecord::RecordInvalid => e
    errors.add(:base, e.message)
  end

  def create_prep_process_step_object
    PrepProcess.transaction do
      begin
        @current_step = @prep_process.current_step_last_object
        @current_step = @prep_process.create_step_object if @current_step.blank?
      rescue NoMethodError, ActiveRecord::RecordInvalid => e
        raise ActiveRecord::Rollback
        @prep_process.fix_current_step
        errors.add(:current_step, e.message)
        return false
      end
    end
  end

  def step_string
    "step_" + prep_process.current_step.humanize
  end

  def next_step_exist?
    @prep_process.current_step < PrepProcess::STEPS_LIMIT
  end

  def previous_step_exist?
    @prep_process.previous_step? > 1
  end

  def next!
    previous_step = @prep_process.current_step
    @prep_process.next_step
    create_prep_process_step_object
    errors.add(
      :current_step,
      "El paso del proceso no púdo cambiar, el paso anterior al intento es: #{previous_step} y el limite de pasos es de 1 a #{PrepProcess::STEPS_LIMIT}") if !step_changed?(previous_step)
  end

  def previous!
    previous_step = @prep_process.current_step
    @prep_process.previous_step
    create_prep_process_step_object
    errors.add(
      :current_step,
      "El paso del proceso no púdo cambiar, el paso anterior al intento es: #{previous_step} y el limite de pasos es de 1 a #{PrepProcess::STEPS_LIMIT}") if !step_changed?(previous_step)
  end

  def step_changed?(previous_step)
    @prep_process.current_step != previous_step
  end

  def finish!
    @prep_process.finish
  end
end