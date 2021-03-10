class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  PER = 5
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
    if params[:sort_expired]
      @tasks = Task.all.order(expire: :asc).page(params[:page]).per(PER)
    elsif params[:sort_priority]
      @tasks = Task.all.order(priority: :asc).page(params[:page]).per(PER)
    else
      @tasks = Task.all.order(created_at: :desc).page(params[:page]).per(PER)
    end

    if params[:task].present?
      if params[:task][:title].present? && params[:task][:progress].present?
        @tasks = @tasks.where('title LIKE ?', "%#{params[:task][:title]}%").page(params[:page]).per(PER)
        @tasks = @tasks.where(progress: params[:task][:progress]).page(params[:page]).per(PER)
      elsif params[:task][:title].present?
        @tasks = @tasks.where('title LIKE ?', "%#{params[:task][:title]}%").page(params[:page]).per(PER)
      elsif params[:task][:progress].present?
        @tasks = @tasks.where(progress: params[:task][:progress]).page(params[:page]).per(PER)
      end
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
    params.require(:task).permit(:title, :content, :expire, :progress, :priority)
  end
  def set_task
    @task = Task.find(params[:id])
  end
end
