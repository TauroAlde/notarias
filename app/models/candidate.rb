class Candidate < ApplicationRecord
  has_one :political_candidacy
  belongs_to :political_party
  belongs_to :main_political_party, class_name: 'PoliticalParty', foreign_key: :main_political_party_id

  scope :for_segment, ->(segment) { joins(political_candidacy: :segment).where('segments.id = ?', segment.id) }
end
