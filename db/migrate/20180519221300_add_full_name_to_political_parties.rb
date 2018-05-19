class AddFullNameToPoliticalParties < ActiveRecord::Migration[5.0]
  def change
    add_column :political_parties, :full_name, :string
  end
end
