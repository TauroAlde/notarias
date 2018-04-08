class PoliticalCandidacy < ApplicationRecord
  has_many :political_parties, through: :candidate
  belongs_to :candidate
  belongs_to :segment
  belongs_to :candidacy
end
