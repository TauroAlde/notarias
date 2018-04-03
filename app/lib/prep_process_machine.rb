class PrepProcessMachine
  include ActiveModel::Model

  attr_accessor :segment, :user, :prep_process, :current_step

  def find_or_create
    @prep_process = PrepProcess.
      find_or_create_by!(processed_segment: segment, segment_processor: user)
    prep_process_step
    @prep_process
  rescue ActiveRecord::RecordInvalid => e
    errors.add(:base, e.message)
  end

  def create
    @prep_process = PrepProcess.create!(processed_segment: segment, segment_processor: user)
  rescue ActiveRecord::RecordInvalid => e
    errors.add(:base, e.message)
  end

  def prep_process_step
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
    case
    when current_step.is_a?(Prep::StepOne)
      "step_one"
    else
      "step_one"
    end
  end

  def next!
    @prep_process.next_step
    prep_process_step
  end

  def previous!
    @prep_process.previous_step
    prep_process_step
  end

  def finish!
    @prep_process.finish
  end
end