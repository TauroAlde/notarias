class CoalitionRelationship < ApplicationRecord
  belongs_to :parent_political_party, class_name: "PoliticalParty"
  belongs_to :political_party, class_name: "PoliticalParty"
end
