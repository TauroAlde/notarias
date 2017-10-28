class Procedure < ApplicationRecord
  belongs_to :creator_user, class_name: "User", foreign_key: :creator_user_id
end
