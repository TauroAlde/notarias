class Authorizer
  attr_accessor :authorizable, :resource, :action, :permissions
  #CRUD_ACTIONs = [:create, :read, :update, :destroy]
  AUTHORIZABLE_COLLECTION_JOINS_CLASS = UserGroup
  AUTHORIZABLE_CLASS = User
  AUTHORIZABLE_COLLECTION_CLASS = Group
  MANAGE = 'manage'
  READ = 'read'

  def initialize(authorizable)
    @authorizable = authorizable
  end

  def authorize(resource, action = MANAGE)
    @resource = resource
    @action = action
    find_permissions
    # First we ask if all the permissions allow 'manage' or the action
    # if the group has this action or manage allowed, it is considered permitted
    # but if there is any permission resulting in false, we go into the deep individual permission check
    if permissions.present?
      all_actions_permitted? || action_permitted?
    else
      false
    end
  end

  def authorize!(resource, action = MANAGE)
    raise AccessDenied.new(I18n.t(:authorization_failed)) unless authorize(resource, action)
    true
  end

  private

  def resource_name
    resource.respond_to?(:new) ? resource.to_s : resource.class
  end

  def all_actions_permitted?
    permissions.all?(&:permitted?)
  end

  def action_permitted?
    permissions.select { |p| p.authorizable == authorizable && p.action == action }.all?(&:permitted?)
  end

  def find_permissions
    @permissions = Permission.find_by_sql(
      <<-SQL
        SELECT permissions.* FROM permissions
        WHERE (
          ( permissions.authorizable_id = #{authorizable.id}
            AND permissions.authorizable_type = '#{authorizable.class.to_s}' )
          #{authorizable_collection_query}
        )
        AND (permissions.action = LOWER('#{MANAGE}') OR permissions.action = LOWER('#{action.to_s}'))
        AND (#{resource_sub_query})
      SQL
    )
  end

  def authorizable_collection_query
    if authorizable.class == AUTHORIZABLE_CLASS
      <<-SQL
        OR
        ( permissions.authorizable_id IN (
            SELECT #{join_table_name}.#{join_table_foreign_key_to_authorizable_collection} FROM #{join_table_name}
            WHERE #{join_table_name}.#{join_table_foreign_key_to_authorizable} = #{authorizable.id}
          ) AND permissions.authorizable_type = '#{AUTHORIZABLE_COLLECTION_CLASS.to_s}'
        )
      SQL
    end
  end

  def join_table_name
    AUTHORIZABLE_COLLECTION_JOINS_CLASS.table_name
  end

  def join_table_foreign_key_to_authorizable
    AUTHORIZABLE_COLLECTION_JOINS_CLASS.reflections[AUTHORIZABLE_CLASS.to_s.downcase].foreign_key
  end

  def join_table_foreign_key_to_authorizable_collection
    AUTHORIZABLE_COLLECTION_JOINS_CLASS.reflections[AUTHORIZABLE_COLLECTION_CLASS.to_s.downcase].foreign_key
  end

  def resource_sub_query
    if resource.respond_to?(:new) || resource.is_a?(String)
      "permissions.featurette_object = '#{resource.to_s}'"
    else
      "permissions.featurette_id = #{resource.id} AND permissions.featurette_type = '#{resource.class.to_s}'"
    end
  end

  class AccessDenied < StandardError; end
end