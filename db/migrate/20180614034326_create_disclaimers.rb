class CreateDisclaimers < ActiveRecord::Migration[5.0]
  def change
    create_table :disclaimers do |t|
      t.integer :user_id, index: true
      t.boolean :accepted, default: false
      t.timestamps
    end
  end
end
