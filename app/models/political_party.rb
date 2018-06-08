class PoliticalParty < ApplicationRecord
  has_many :candidates
  has_many :political_candidacies
  has_many :candidacies, through: :political_candidacies
  has_many :coalition_relationships
  has_many :parent_political_parties, through: :coalition_relationships, foreign_key: :parent_political_party_id, class_name: "PoliticalParty"
  has_many :child_political_parties, through: :coalition_relationships, foreign_key: :political_party_id, class_name: "PoliticalParty"
  has_many :votes

  scope :coalitions, -> { where(coalition: true) }

  validates :name, presence: true, uniqueness: true

  def all_political_parties
    if coalition?
      [self] + parent_political_parties
    else
      self
    end
  end
end