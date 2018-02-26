class AddUniquenessIndexForActionAndPermission < ActiveRecord::Migration[5.0]
  def change
    add_index :permissions, [:featurette_id, :featurette_type, :authorizable_id, :authorizable_type, :action], unique: true, name: "index_permissions_on_ftrt_object_and_authorizable_and_action"
    add_index :permissions, [:featurette_object, :authorizable_id, :authorizable_type, :action], unique: true, name: "index_permissions_on_featurette_and_authorizable_and_action"
  end
end
