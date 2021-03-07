class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if params[:back]
      render :new
    else
      if @task.save
        redirect_to task_path(@task.id), notice: "タスクを作成しました！"
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
    @tasks = Task.all.order(created_at: "DESC")
    if params[:sort_expired]
      @tasks = Task.order(expire: :asc)
    #elsif params[:created_at]
    #  @tasks = Task.where(user_id:current_user.id).order(created_at: :desc)
    #elsif params[:priority]
    #  @tasks = Task.where(user_id:current_user.id).order(priority: :asc)
    end
  end

  def show
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: "タスクを削除しました！"
  end

  private
  def task_params
    params.require(:task).permit(:title, :content, :expire)
  end
  def set_task
    @task = Task.find(params[:id])
  end
end
