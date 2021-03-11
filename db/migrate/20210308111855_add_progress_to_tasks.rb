class AddProgressToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :progress, :string
  end
end
