class AddExpireToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :expire, :datetime, default: '2021-12-31', null: false 
  end
end
