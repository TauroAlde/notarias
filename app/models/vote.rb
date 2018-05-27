class Vote < ApplicationRecord
  belongs_to :step_four, class_name: "Prep::StepFour", foreign_key: :step_four_id
  belongs_to :political_candidacy
  belongs_to :political_party
end
