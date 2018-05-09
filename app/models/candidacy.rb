class Candidacy < ApplicationRecord
  has_many :political_candidacies

  has_many :segments, through: :political_candidacies
  has_many :candidates, through: :political_candidacies
  has_many :political_parties, through: :political_candidacies

  PRESIDENCIA = 'Presidencia'

  def self.presidential
    find_by(name: PRESIDENCIA)
  end
end
