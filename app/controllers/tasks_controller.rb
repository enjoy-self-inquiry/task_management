class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  def new
    @task = Task.new
  end
  def create
    @task = task.new(task_params)
    if params[:back]
      render :new
    else
      if @task.save
        redirect_to tasks_path, notice: "タスクを作成しました！"
      else
        render :new
      end
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to tasks_path, notice: "タスクを編集しました！"
    else
      render :edit
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
  def set_task
    @task = Task.find(params[:id])
  end
end
