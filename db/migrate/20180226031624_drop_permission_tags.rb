class DropPermissionTags < ActiveRecord::Migration[5.0]
  def change
    drop_table :permission_tags
  end
end
