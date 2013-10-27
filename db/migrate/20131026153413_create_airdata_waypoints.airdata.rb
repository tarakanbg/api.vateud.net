# This migration comes from airdata (originally 20120729134341)
class CreateAirdataWaypoints < ActiveRecord::Migration
  def change
    create_table :airdata_waypoints do |t|
      t.string :ident
      t.string :name
      t.float :freq
      t.float :lat
      t.float :lon
      t.integer :range
      t.integer :elevation
      t.string :country_code

      t.timestamps
    end
  end
end
