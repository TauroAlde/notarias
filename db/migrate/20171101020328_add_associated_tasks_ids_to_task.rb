class AddAssociatedTasksIdsToTask < ActiveRecord::Migration[5.0]
  def change
    #add_column :tasks, :associated_tasks_ids, :string
    add_column :tasks, :associated_tasks_ids, :text, array: true, default: []
  end
end
