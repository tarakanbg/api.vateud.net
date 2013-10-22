class ChangePriorityTypeInStaffMembers < ActiveRecord::Migration
  def change
    remove_column :staff_members, :priority
    add_column :staff_members, :priority, :integer
  end

  
end
