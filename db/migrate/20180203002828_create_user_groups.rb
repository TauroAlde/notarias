class CreateUserGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :user_groups do |t|
      t.integer :user:id
      t.integer :groups_id
      t.timestamps
    end
  end
end
