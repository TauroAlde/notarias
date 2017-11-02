class TaskCatalogsController < ApplicationController


  def index
    @task = Task.all.order(:id)
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def create
    tasks = Task.new(task_catalogs_params)
    if task.save
      redirect_to tasks_path
    else
      redirect_to new_task_path
    end
  end

  def update
    @task = Task.find(params[:id])

    if @task.update(task_catalogs_params)
      redirect_to tasks_path
    else
      redirect_to edit_task_path
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    redirect_to tasks_path
  end

  private

    def task_catalogs_params
    params.require(:task).
      permit(:name)
  end

end
