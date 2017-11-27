class CreateTaskOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :task_orders do |t|
      t.integer :procedure_id
      t.integer :task_id
      t.integer :order

      t.timestamps
    end
  end
end
