class Prep::StepFive < ApplicationRecord
  belongs_to :prep_process

  mount_uploader :file, EvidenceUploader

  validates :file, presence: true
end
