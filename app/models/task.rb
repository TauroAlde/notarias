class Task < ApplicationRecord
  #serialize :associated_tasks_ids, Array

  # Fetches tasks requiring ANY of given ids ex:
  # db: [1,3,4]  ids: [1,5]
  #     [2,3]
  #     [1,4]
  #     [5]
  # will return objects with: [1,3,4], [1,4] and [5]
  scope :requiring_any, ->(ids) { where("'{?}' && associated_tasks_ids", ids) }

  # Fetches tasks requiring ANY of given ids ex:
  # db: [1,3,4]  ids: [5, 1]
  #     [2,3]
  #     [1,4]
  #     [1,5,2]
  # will return objects with: [1,5,2] only. Because only that one contains the full list of ids
  scope :requiring_all, ->(ids) { where("'{?}' <@ associated_tasks_ids", ids) }

  # returns list of required tasks
  def required_tasks
    self.class.where("id IN (?)", associated_tasks_ids)
  end

  # returns list of tasks with the current tasks required
  #
  # [1,2,3]  id: 1
  # [1,5]
  # [2,5]
  #
  # will return: [1,2,3] and [1,5]
  def child_tasks
    self.class.where("'?' = ANY (associated_tasks_ids)", id)
  end

  def add_required_task(task)
    self.associated_tasks_ids += [task.id]
    save
  end

  def remove_required_task(task)
    return false unless is_required?(task)
    associated_tasks_ids.delete(task.id.to_s)
    save
  end

  def is_required?(task)
    associated_tasks_ids.include?(task.id.to_s)
  end
end
