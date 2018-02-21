module CustomValidators
  class PermissionValidator < ActiveModel::Validator
    def validate(record)
      if !record.featurette && record.featurette_object.blank?
        record.errors.add :base, I18n.t(:featurette_object_or_resource_is_blank)
      elsif record.featurette && !record.featurette_object.nil?
        record.errors.add :base, I18n.t(:cant_add_a_featurette_and_a_resource_at_the_same_time)
      elsif !find_permission(record).blank?
        record.errors.add :base, I18n.t(:permission_already_exists)
      end
    end

    private

    def find_permission(record)
      query = Permission.where(authorizable: record.authorizable)
      query = query.for_featurette(record.featurette) if record.featurette
      query = query.for_featurette_object(record.featurette_object) if record.featurette_object
      query
    end
  end
end