class Candidacy < ApplicationRecord
  has_many :political_candidacies

  has_many :segments, through: :political_candidacies
  has_many :candidates, through: :political_candidacies
  has_many :political_parties, through: :political_candidacies

  PRESIDENCIA = 'Presidencia'
  PRESIDENTE_MUNICIPAL = 'Presidente Municipal'
  DIPUTADO_FEDERAL_D1 = 'Diputado Federal D1'
  DIPUTADO_FEDERAL_D2 = 'Diputado Federal D2'
  DIPUTADO_FEDERAL_D3 = 'Diputado Federal D3'
  DIPUTADO_FEDERAL_D4 = 'Diputado Federal D4'
  SENADOR_PRIMERA_FORMULA = 'Senador primera fórmula'
  SENADOR_SEGUNDA_FORMULA = 'Senador segunda fórmula'

  def self.presidential
    find_by(name: PRESIDENCIA)
  end
end
