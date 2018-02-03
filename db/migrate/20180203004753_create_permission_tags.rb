class CreatePermissionTags < ActiveRecord::Migration[5.0]
  def change
    create_table :permission_tags do |t|
      t.string :name
      t.integer :permission_id
      t.timestamps
    end
  end
end
