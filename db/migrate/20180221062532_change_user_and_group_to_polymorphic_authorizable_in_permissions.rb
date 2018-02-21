class ChangeUserAndGroupToPolymorphicAuthorizableInPermissions < ActiveRecord::Migration[5.0]
  def change
    remove_column :permissions, :user_id
    remove_column :permissions, :group_id
    add_column :permissions, :authorizable_id, :integer
    add_column :permissions, :authorizable_type, :string
  end
end
