class TaskHierarchy < ApplicationRecord
  belongs_to :required_task, class_name: "Task", foreign_key: :required_task_id
  belongs_to :requirer_task, class_name: "Task", foreign_key: :requirer_task_id
end
