class Prep::StepThree < ApplicationRecord
  belongs_to :prep_process, touch: true

  validates :voters_count, presence: true
end
