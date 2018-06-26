class Prep::StepTwo < ApplicationRecord
  belongs_to :prep_process, touch: true
end
