class UserPreference < ApplicationRecord
  belongs_to :user
  belongs_to :preference

  validates :user_id, presence: true
  validates :preference_id, presence: true
  validates :value, presence: true
end
