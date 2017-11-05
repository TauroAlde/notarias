class TaskOrder < ApplicationRecord
  belongs_to :procedure
  belongs_to :task
end
