class ChangeNamesForNameFromUsers < ActiveRecord::Migration[5.0]
  def change
  	rename_column :users, :names, :name
  end
end
