class CreateTaskHierarchies < ActiveRecord::Migration[5.0]
  def change
    create_table :task_hierarchies do |t|
      t.integer :required_task_id
      t.integer :requirer_task_id
      t.integer :procedure_id

      t.timestamps
    end
  end
end
