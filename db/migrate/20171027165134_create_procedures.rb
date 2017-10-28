class CreateProcedures < ActiveRecord::Migration[5.0]
  def change
    create_table :procedures do |t|
      t.string :name
      t.integer :creator_user_id
      t.float :version
      t.timestamps
    end
  end
end
