class AddNominalCountToSegments < ActiveRecord::Migration[5.0]
  def change
    add_column :segments, :nominal_count, :integer, default: 0
  end
end
