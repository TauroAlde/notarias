class Preference < ApplicationRecord

  has_many :user_preferences
  has_many :users, through: :user_preferences
  
  validates :name, presence: true
  validates :default_values, presence: true
  validates :field_type, presence: true

  enum field_type: [:text, :textarea, :number, :select_field, :checkbox,
                    :radio, :date, :email, :password]
end
