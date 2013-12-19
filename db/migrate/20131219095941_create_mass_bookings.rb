class CreateMassBookings < ActiveRecord::Migration
  def change
    create_table :mass_bookings do |t|
      t.integer :admin_user_id

      t.timestamps
    end
  end
end
