class AuthorizationBuilder
  # Adds all behaviour of an common model
  include ActiveModel::Model

  DEFAULT_ACTION = "read"

  attr_accessor :authorizable, :resource, :action, :permission

  validates :authorizable, :resource, :action, presence: true

  def save
    begin
      @permission = Permission.new(
        {
          authorizable: authorizable,
          action: action || DEFAULT_ACTION
        }.merge(resource_permission_type)
      )
      @permission.save!
    rescue ActiveRecord::RecordInvalid => e
      @permission.errors.full_messages.each do |error|
        errors.add(:base, error)
      end
    end
  end

  def action=(action = DEFAULT_ACTION)
    @action = action
  end

  def resource_permission_type
    if resource.respond_to?(:new) || resource.is_a?(String)
      { featurette_object: resource.to_s }
    else
      { featurette: resource }
    end
  end
end