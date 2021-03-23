class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  PER = 3
  def new
    @task = Task.new
  end

  def create
    @task = current_user.tasks.build(task_params)
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
    @task = Task.find(params[:id])
    if @task.user != current_user
      redirect_to tasks_path, alert: "不正なアクセスです。"
    end
  end

  def update
    if @task.update(task_params)
      redirect_to tasks_path, notice: "タスクを編集しました！"
    else
      render :edit
    end
  end

  def index
      @tasks = Task.where(user_id:current_user.id).order(created_at: :desc)
      @tasks = Task.where(user_id:current_user.id).order(expire: :asc) if params[:sort_expired]
      @tasks = Task.where(user_id:current_user.id).order(priority: :asc) if params[:sort_priority]

    if params[:task].present?
        @tasks = @tasks.where('title LIKE ?', "%#{params[:task][:title]}%") if params[:task][:title].present? && params[:task][:progress].present?
        @tasks = @tasks.where(progress: params[:task][:progress]) if params[:task][:title].present? && params[:task][:progress].present?
        @tasks = @tasks.where('title LIKE ?', "%#{params[:task][:title]}%") if params[:task][:title].present?
        @tasks = @tasks.where(progress: params[:task][:progress]) if params[:task][:progress].present?
    end
    @tasks = @tasks.page(params[:page]).per(PER)
  end

  def show
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: "タスクを削除しました！"
  end

  private
  def task_params
    params.require(:task).permit(:title, :content, :expire, :progress, :priority)
  end
  def set_task
    @task = Task.find(params[:id])
  end
end
