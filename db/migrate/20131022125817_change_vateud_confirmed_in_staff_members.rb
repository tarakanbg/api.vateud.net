class ChangeVateudConfirmedInStaffMembers < ActiveRecord::Migration
  def change
    remove_column :staff_members, :veteud_confirmed
    add_column :staff_members, :vateud_confirmed, :boolean, :default => false
  end

end
