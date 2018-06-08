class AddNullVotesToPrepStepFours < ActiveRecord::Migration[5.0]
  def change
    add_column :prep_step_fours, :null_votes, :integer, default: 0
  end
end
