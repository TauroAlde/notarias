class Prep::StepFour < ApplicationRecord
  belongs_to :prep_process, touch: true
  has_many :votes

  accepts_nested_attributes_for :votes
end
