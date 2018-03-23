class CreateGroups < ActiveRecord::Migration[5.0]
  def change
    change_table :groups do |t|
      t.string :name
      t.integer :segment_id
      t.timestamps
    end
  end
end
