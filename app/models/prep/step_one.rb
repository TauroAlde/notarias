class Prep::StepOne < ApplicationRecord
  belongs_to :prep_process, touch: true
end
