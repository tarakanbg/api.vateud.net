# This migration comes from airdata (originally 20120729093219)
class CreateAirdataAirports < ActiveRecord::Migration
  def change
    create_table :airdata_airports do |t|
      t.string :icao
      t.string :name
      t.float :lat
      t.float :lon
      t.integer :elevation
      t.integer :ta
      t.integer :msa

      t.timestamps
    end
  end
end
