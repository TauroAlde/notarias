class AddDistrictIdToPoliticalCandidacies < ActiveRecord::Migration[5.0]
  def change
    add_column :political_candidacies, :district_id, :integer, index: true
  end
end
