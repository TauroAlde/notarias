class District < ApplicationRecord
  has_many :segments
  has_many :political_candidacies

  validates :district_number, presence: true
end
