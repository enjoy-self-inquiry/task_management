module Admin::UsersHelper
  def admin_choose_new_or_edit
    if action_name == "new"  || action_name == "create"
      admin_users_path
    elsif action_name == "edit"
      admin_user_path
    end
  end
end
