class Permission < ApplicationRecord
  belongs_to :featurette, polymorphic: true, optional: true
  belongs_to :authorizable, polymorphic: true
  has_many :permission_tags

  scope :for_featurette, ->(featurette) { where(featurette: featurette) }
  scope :for_authorizable, ->(authorizable) { where(authorizable: authorizable) }
  scope :for_featurette_object, ->(featurette_object) { where(featurette_object: featurette_object) }

  validates_with CustomValidators::PermissionValidator
  #validates_uniqueness_of :authorizable_id, scope: [:authorizable_type], conditions: -> {
  #  where("(featurette_id IS NULL AND featurette_object IS NOT NULL) OR (featurette_id IS NOT NULL AND featurette_object IS NULL)")
  #}, if: ->(permission) { binding.pry }
end
