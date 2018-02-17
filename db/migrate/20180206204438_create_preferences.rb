class CreatePreferences < ActiveRecord::Migration[5.0]
  def change
    create_table :preferences do |t|
      t.string :name
      t.text :description
      t.text :default_values
      t.boolean :encrypted
      t.integer :field_type 
      t.timestamps
    end
  end
end
