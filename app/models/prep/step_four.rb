class Prep::StepFour < ApplicationRecord
  belongs_to :prep_process
  has_many :votes

  accepts_nested_attributes_for :votes
end
