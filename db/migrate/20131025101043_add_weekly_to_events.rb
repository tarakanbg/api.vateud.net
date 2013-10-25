class AddWeeklyToEvents < ActiveRecord::Migration
  def change
    add_column :events, :weekly, :boolean, :default => false
  end
end
