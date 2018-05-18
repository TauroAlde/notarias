class District < ApplicationRecord
  validates :district_number, presence: true
end
