class CreateVotes < ActiveRecord::Migration[5.0]
  def change
    create_table :votes do |t|
      t.integer :step_four_id, index: true
      t.integer :political_party_id, index: true
      t.integer :political_candidacy_id, index: true
      t.integer :votes_count, default: 0
      t.timestamps
    end
  end
end
