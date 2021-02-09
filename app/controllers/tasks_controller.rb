class TasksController < ApplicationController
  def new
    @task = Task.new
  end
  def create
    @task = Task.new(task_params)
    if @task.save
    else
      render :new
    end
  end
  def index
    @tasks = Task.all
  end
  def show
    @task = Task.find(params[:id])
  end
  private
  def task_params
    params.require(:task).permit(:title, :content)
  end
end
