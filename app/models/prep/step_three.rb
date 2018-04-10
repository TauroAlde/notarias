class Prep::StepThree < ApplicationRecord
  belongs_to :prep_process

  serialize :data, JSON
end
