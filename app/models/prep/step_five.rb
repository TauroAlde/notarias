class Prep::StepFive < ApplicationRecord
  belongs_to :prep_process, touch: true

  mount_uploader :file, EvidenceUploader
end
