class AddWeeklyHashToEvents < ActiveRecord::Migration
  def change
    add_column :events, :weekly_hash, :string
  end
end
