class AddMainPoliticalPartyToCandidate < ActiveRecord::Migration[5.0]
  def change
    add_column :candidates, :main_political_party_id, :integer, index: true
  end
end
