class RemoveDefaultFromExpires < ActiveRecord::Migration[5.2]
  def change
    change_column_default :tasks, :expire, nil
  end
end
