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
    if params[:sort_expired]
      @tasks = Task.all.order(expire: :asc)
    else
      @tasks = Task.all.order(created_at: :desc)
    end
    if params[:task].present?
      if params[:task][:title].present? && params[:task][:progress].present?
        #両方title and progressが成り立つ検索結果を返す
        @tasks = @tasks.where('title LIKE ?', "%#{params[:task][:title]}%")
        @tasks = @tasks.where(progress: params[:task][:progress])
        #渡されたパラメータがtask titleのみだったとき
      elsif params[:task][:title].present?
        @tasks = @tasks.where('title LIKE ?', "%#{params[:task][:title]}%")
        #渡されたパラメータがステータスのみだったとき
      elsif params[:task][:progress].present?
        @tasks = @tasks.where(progress: params[:task][:progress])
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
    params.require(:task).permit(:title, :content, :expire, :progress)
  end
  def set_task
    @task = Task.find(params[:id])
  end
end
