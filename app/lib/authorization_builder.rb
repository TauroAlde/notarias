class AuthorizationBuilder
  # Adds all behaviour of an common model
  include ActiveModel::Model

  attr_accessor :authorizable, :resource, :actions, :permission

  def add_permission
    begin
      @permission = Permission.new(
        {
          authorizable: authorizable,
          permission_tags: build_permission_tags
        }.merge(resource_permission_type)
      )
      @permission.save!
    rescue ActiveRecord::RecordInvalid => e
      @permission.errors.full_messages.each do |error|
        errors.add(:base, error)
      end
    end
  end

  def resource_permission_type
    if resource.respond_to?(:new)
      { featurette_object: resource.to_s }
    else
      { featurette: resource }
    end
  end

  def build_permission_tags
    (@actions || [:read]).map { |action| PermissionTag.new(name: action) }
  end
end