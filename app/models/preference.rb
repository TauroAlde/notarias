class Preference < ApplicationRecord

  has_many :user_preferences
  has_many :users, through: :user_preferences
  
  validates :name, presence: true
  validates :default_values, presence: true
  validates :field_type, presence: true

  enum field_type: { text: 0, textarea: 1, number: 2, select_field: 3, checkbox: 4,
                    radio: 5, date: 6, email: 7, password: 8 }

end
