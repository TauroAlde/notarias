class Candidacy < ApplicationRecord
  has_many :political_candidacies
  has_many :segment_candidacies
  has_many :segments, through: :segment_candidacies
  has_many :candidates, through: :political_candidacies
  has_many :political_parties, through: :political_candidacies
end
