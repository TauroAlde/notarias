class AddFileToPrepStepFives < ActiveRecord::Migration[5.0]
  def change
    add_column :prep_step_fives, :file, :string
  end
end
