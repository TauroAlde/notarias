class ParentPoliticalParty < ApplicationRecord
  belongs_to :political_party
  belongs_to :parent_political_party

  validates :parent_political_party_id, presence: true
  validates :political_party_id, presence: true
end
