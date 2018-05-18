class AddDistrictNumberToSegments < ActiveRecord::Migration[5.0]
  def change
    add_column :segments, :district_id, :integer, index: true
  end
end
