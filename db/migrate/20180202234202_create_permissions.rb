class CreatePermissions < ActiveRecord::Migration[5.0]
  def change
    create_table :permissions do |t|
      t.string :featurette_object
      t.string :featurette_type
      t.integer :featurette_id
      t.integer :user_id
      t.integer :group_id
      t.boolean :permitted
      t.timestamps
    end
  end
end
