class Group < ApplicationRecord
  has_many :permissions
  has_many :users, through: :user_group
end
