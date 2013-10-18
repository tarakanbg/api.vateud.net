class RemoveAdminUserIdFromEvents < ActiveRecord::Migration
  def up
    remove_column :events, :admin_user_id
  end

  def down
    add_column :events, :admin_user_id, :integer
  end
end
