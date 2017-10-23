class UserRole < ApplicationRecord
  belongs_to :user_role
  belongs_to :user
end
