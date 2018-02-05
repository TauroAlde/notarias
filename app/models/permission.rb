class Permission < ApplicationRecord
  belongs_to :featurete, polymorphic: true
  belongs_to :user
  belongs_to :group
  has_many :permission_tags
end
