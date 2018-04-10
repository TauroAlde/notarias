class CreatePrepStepThrees < ActiveRecord::Migration[5.0]
  def change
    create_table :prep_step_threes do |t|
      t.integer :prep_process_id
      t.text :data, default: "{}"
      t.timestamps
    end
  end
end
