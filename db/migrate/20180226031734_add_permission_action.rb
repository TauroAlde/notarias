class AddPermissionAction < ActiveRecord::Migration[5.0]
  def change
    add_column :permissions, :action, :string, default: Authorizer::MANAGE
    change_column :permissions, :permitted, :boolean, default: true
  end
end
