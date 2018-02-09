class ChangeColumnFieldToFieldTypeOnPreferenceTable < ActiveRecord::Migration[5.0]
  def change
    rename_column :preferences, :field, :field_type
  end
end
