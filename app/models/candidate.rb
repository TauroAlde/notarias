class Candidate < ApplicationRecord
  has_one :political_candidacy
  belongs_to :political_party
end
