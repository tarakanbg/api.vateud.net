class CreateAtcBookings < ActiveRecord::Migration
  def change
    create_table :atc_bookings do |t|
      t.string :controller
      t.string :position
      t.datetime :starts
      t.datetime :ends
      t.integer :admin_user_id
      t.integer :eu_id

      t.timestamps
    end
  end
end
