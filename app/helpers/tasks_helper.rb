module TasksHelper
  def choose_new_or_edit
    if action_name == 'new'
      confirm_tasks_path
    elsif action_name == 'edit'
      task_path
    end
  end
end
