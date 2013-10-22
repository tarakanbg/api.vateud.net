class CreateStaffMembers < ActiveRecord::Migration
  def change
    create_table :staff_members do |t|
      t.string :vacc_code
      t.string :callsign
      t.integer :cid
      t.string :email
      t.string :position
      t.string :priority
      t.boolean :veteud_confirmed, :default => false

      t.timestamps
    end
  end
end
