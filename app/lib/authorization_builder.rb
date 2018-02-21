class AuthorizationBuilder
  attr_accessor :user, :group, :resource, :actions, @permission

  def initialize(user: nil, group: nil, resource: nil, actions: [:all])
    @user = user
    @group = group
    raise AuthorizationBuilding::AuthorizableNil.new(I18n.t(:no_authorizable_passed_as_argument)) if @user.blank? && @group.blank?
    @resource = resource
    raise AuthorizationBuilding::ResourceNil.new(I18n.t(:no_resource_passed_as_argument)) if @resource.blank?
    @action = action
  end

  def add_permission
    @permission = Permission.create(
      {
        user: @user,
        group: @group,
      }.merge(:resource_permission_type)
    )
  end

  def resource_permission_type
    if resource.respond_to?(:new)
      { featurette_object: resource.to_s }
    else
      { featurette: resource }
    end
  end

  class AuthorizationBuilding::AuthorizableNil < StandardError; end
  class AuthorizationBuilding::ResourceNil < StandardError; end
end